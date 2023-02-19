module "aws-dev" {
  source          = "../../infraestrutura"
  imagem          = "ami-00874d747dde814fa"
  instancia       = "t2.micro"
  regiao_aws      = "us-east-1"
  chave           = "IaC-DEV"
  tagName         = "Terraform Ansible - Desenv"
  grupoDeSeguraca = "Desenvolvimento"
  minimoGrupoAS   = 1
  maximoGrupoAS   = 1
  nomeGrupoAS     = "DEV-AS"
  producao        = false
}

output "IP" {
  value = module.aws-dev.IP_Publico
}