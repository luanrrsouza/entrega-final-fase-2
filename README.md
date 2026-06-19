# Task Manager AWS

Aplicação Task Manager com deploy na AWS usando Terraform.

## Visao Geral
O projeto entrega uma aplicação web simples para criar, listar, atualizar e excluir tarefas.

## Arquitetura
- Frontend: HTML, CSS e JavaScript
- Backend: Node.js com Express
- Banco de dados: PostgreSQL no RDS
- Infraestrutura: VPC, subnets públicas e privadas, ALB, EC2 e security groups

## Pre-requisitos
- Conta AWS ativa
- Credenciais da AWS configuradas no ambiente local
- Terraform instalado
- Repositório GitHub com o código publicado

## Estrutura
- `app/`: aplicação Node.js
- `terraform/`: infraestrutura como código

## Variaveis Importantes
Confira `terraform/variables.tf` antes do deploy:
- `aws_region`
- `db_username`
- `db_password`
- `db_name`
- `github_repo_url`

## Deploy
Execute na pasta `terraform`:

```bash
terraform init
terraform plan
terraform apply
```

Ao final, o Terraform exibe:
- DNS do Load Balancer
- endpoint do RDS

## Acesso
Abra no navegador o DNS do ALB mostrado no output do Terraform.

## Validacao
Verifique:
- EC2 em estado `Executando`
- Target Group com instância saudável
- RDS com status `available`
- Aplicação criando tarefas normalmente

## Como testar
1. Abra a URL do ALB
2. Crie uma tarefa
3. Confira se ela aparece na lista

## Solucao de Problemas
- Se a tela mostrar erro ao carregar banco, confira se o RDS está `available`
- Se houver erro de conexão, confira os logs da EC2 com `pm2 logs taskapp`
- Se o SSH da instância falhar, valide a regra da porta `22` no security group

## Como parar tudo
Para evitar cobranças, destrua a infraestrutura:

```bash
terraform destroy
```

## Observacao
Depois do `destroy`, confirme na AWS Console que não restaram recursos ativos em EC2, RDS e Load Balancers.
