# Entrega Final da Fase 2 - Cloud AWS com Terraform

Esta é a entrega final da disciplina de Cloud. Trata-se de uma aplicação "Task Manager" completa, provisionada 100% via Infraestrutura como Código (Terraform).

## Arquitetura
1. **Frontend**: HTML, CSS (Tailwind via CDN) e JavaScript simples.
2. **Backend**: Node.js com Express para criar a API REST.
3. **Banco de Dados**: AWS RDS PostgreSQL.
4. **Infraestrutura**:
   - VPC isolada.
   - Application Load Balancer (ALB) em subnets públicas.
   - Instância EC2 rodando o Node.js em subnet pública (mas protegida pelo Security Group, recebendo tráfego apenas do ALB).
   - Instância RDS PostgreSQL em subnets privadas, acessível apenas pelo EC2.

## Como fazer o deploy

1. Suba todo este código para um repositório no seu GitHub (Ele precisa estar Público ou ser acessado via Token).
2. Tenha as credenciais da AWS (`AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`) configuradas no seu ambiente local.
3. Abra o arquivo `terraform/variables.tf` e altere a variável `github_repo_url` para a URL do seu repositório:
   ```hcl
   variable "github_repo_url" {
     default = "https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git"
   }
   ```
4. Navegue até a pasta `terraform` no seu terminal:
   ```bash
   cd terraform
   ```
5. Inicialize o Terraform:
   ```bash
   terraform init
   ```
6. Revise os recursos que serão criados:
   ```bash
   terraform plan
   ```
7. Aplique a infraestrutura (digite `yes` quando solicitado):
   ```bash
   terraform apply
   ```
8. Aguarde o fim do provisionamento (cerca de 5 a 8 minutos por causa do RDS). No final, o terminal exibirá o DNS do Load Balancer:
   ```text
   load_balancer_dns = "http://taskapp-alb-xxxx.us-east-1.elb.amazonaws.com"
   ```
9. Abra o DNS gerado no navegador (pode levar mais 1 ou 2 minutos para o EC2 instalar o Node.js e baixar o código. Se der "502 Bad Gateway", aguarde um momento e recarregue a página).

## Finalização e Destruição (MUITO IMPORTANTE)
Após testar e gravar o vídeo evidenciando o funcionamento, DESTRUA a infraestrutura para evitar cobranças indesejadas no seu cartão de crédito:
```bash
terraform destroy
```
*(Digite `yes` quando solicitado).*
