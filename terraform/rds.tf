# Grupo de Subnets do RDS (colocando o banco nas subnets privadas)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "taskapp-rds-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "TaskApp-RDS-Subnet-Group"
  }
}

# Instância do PostgreSQL no RDS
resource "aws_db_instance" "postgres" {
  identifier             = "taskapp-postgres"
  engine                 = "postgres"
  engine_version         = "15" # Ou a versão mais recente suportada na região
  instance_class         = "db.t3.micro" # Free tier elegível em contas novas
  allocated_storage      = 20
  storage_type           = "gp2"
  
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  skip_final_snapshot    = true # Para não gerar snapshot quando rodar terraform destroy
  publicly_accessible    = false # Apenas o EC2 na VPC poderá acessar

  tags = {
    Name = "TaskApp-PostgreSQL"
  }
}
