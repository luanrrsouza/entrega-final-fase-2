output "load_balancer_dns" {
  description = "Acesse a aplicação no navegador usando este endereço"
  value       = "http://${aws_lb.app_alb.dns_name}"
}

output "rds_endpoint" {
  description = "Endpoint do banco de dados (Apenas para fins informativos)"
  value       = aws_db_instance.postgres.address
}
