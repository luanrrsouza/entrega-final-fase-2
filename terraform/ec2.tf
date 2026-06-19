# Buscar a imagem mais recente do Amazon Linux 2023
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Instância EC2
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro" # Free tier elegível
  
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true # Precisa de IP público para baixar os pacotes da internet

  # Script de inicialização que roda assim que a máquina liga
  user_data = <<-EOF
              #!/bin/bash
              
              # Atualizar pacotes
              yum update -y
              
              # Instalar Node.js 18 e Git
              curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
              yum install -y nodejs git
              
              # Baixar o código do GitHub
              cd /home/ec2-user
              git clone ${var.github_repo_url} repo
              
              # Entrar na pasta da aplicação (garanta que seu repositório terá a pasta 'app')
              cd /home/ec2-user/repo/app
              
              # Instalar dependências da aplicação
              npm install
              
              # Instalar o PM2 globalmente para manter a aplicação rodando
              npm install -g pm2
              
              # Configurar as variáveis de ambiente com os dados do RDS criados pelo Terraform
              export DB_HOST="${aws_db_instance.postgres.address}"
              export DB_USER="${var.db_username}"
              export DB_PASSWORD="${var.db_password}"
              export DB_NAME="${var.db_name}"
              export PORT=8080
              
              # Iniciar o servidor Node.js
              pm2 start server.js --name "taskapp"
              
              # Garantir que o PM2 inicie com o servidor (Opcional)
              pm2 startup systemd -u ec2-user --hp /home/ec2-user
              pm2 save
              EOF

  tags = {
    Name = "TaskApp-EC2-Node"
  }

  # Aguardar o RDS estar pronto antes de criar o EC2
  depends_on = [aws_db_instance.postgres]
}

# Anexar a instância EC2 ao Target Group do Load Balancer
resource "aws_lb_target_group_attachment" "app_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server.id
  port             = 8080
}
