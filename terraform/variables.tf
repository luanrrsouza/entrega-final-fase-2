variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  default     = "us-east-1"
}

variable "db_username" {
  description = "Nome de usuário mestre do banco de dados"
  default     = "dbadmin"
}

variable "db_password" {
  description = "Senha do banco de dados (deve ter no mínimo 8 caracteres)"
  default     = "SenhaSuperSecreta123!"
  sensitive   = true
}

variable "db_name" {
  description = "Nome do banco de dados inicial"
  default     = "taskdb"
}

variable "github_repo_url" {
  description = "URL do seu repositório GitHub contendo o código da aplicação (Pasta app)"
  default     = "https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git"
}
