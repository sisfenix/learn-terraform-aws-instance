module "aws-prd" {
  source          = "../../infraestrutura"
  imagem          = "ami-00874d747dde814fa"
  instancia       = "t2.micro"
  regiao_aws      = "us-east-1"
  chave           = "IaC-PRD"
  tagName         = "Terraform Ansible - Producao"
  grupoDeSeguraca = "Producao"
  minimoGrupoAS   = 1
  maximoGrupoAS   = 10
  nomeGrupoAS     = "PRD-AS"
}

output "IP" {
  value = module.aws-prd.IP_Publico
}