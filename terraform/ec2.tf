data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
              yum install -y nodejs git
              cd /home/ec2-user
              git clone ${var.github_repo_url} repo
              cd /home/ec2-user/repo/app
              npm install
              npm install -g pm2
              export DB_HOST="${aws_db_instance.postgres.address}"
              export DB_USER="${var.db_username}"
              export DB_PASSWORD="${var.db_password}"
              export DB_NAME="${var.db_name}"
              export PORT=8080
              pm2 start server.js --name "taskapp"
              pm2 startup systemd -u ec2-user --hp /home/ec2-user
              pm2 save
              EOF

  tags = {
    Name = "TaskApp-EC2-Node"
  }

  depends_on = [aws_db_instance.postgres]
}

resource "aws_lb_target_group_attachment" "app_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server.id
  port             = 8080
}
