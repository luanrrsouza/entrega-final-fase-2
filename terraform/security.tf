# Security Group do Application Load Balancer
# Permite tráfego HTTP (80) da internet
resource "aws_security_group" "alb_sg" {
  name        = "taskapp-alb-sg"
  description = "Permitir trafego HTTP de entrada para o ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TaskApp-ALB-SG"
  }
}

# Security Group da Instância EC2
# Permite acesso HTTP (8080) *apenas* a partir do ALB
# Permite SSH (22) caso você queira acessar para debug
resource "aws_security_group" "ec2_sg" {
  name        = "taskapp-ec2-sg"
  description = "Permitir trafego do ALB para o Node.js"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Descomente abaixo se quiser permitir SSH de qualquer lugar (não recomendado em prod)
  /*
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  */

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TaskApp-EC2-SG"
  }
}

# Security Group do Banco de Dados (RDS)
# Permite acesso (5432) *apenas* a partir da instância EC2
resource "aws_security_group" "rds_sg" {
  name        = "taskapp-rds-sg"
  description = "Permitir acesso do EC2 ao PostgreSQL"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TaskApp-RDS-SG"
  }
}
