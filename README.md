# Entrega Final da Fase 2

Aplicação Task Manager provisionada com Terraform na AWS.

## Componentes
- Frontend em HTML, CSS e JavaScript.
- Backend em Node.js com Express.
- Banco PostgreSQL no RDS.
- VPC, ALB, EC2 e security groups via Terraform.

## Deploy
1. Suba o código para um repositório GitHub público.
2. Configure `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`.
3. Ajuste `terraform/variables.tf` com a URL do seu repositório.
4. Execute:
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```
5. Abra o DNS do Load Balancer exibido no final.

## Limpeza
Depois do teste, destrua a infraestrutura:
```bash
terraform destroy
```
