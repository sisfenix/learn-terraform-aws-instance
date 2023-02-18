module "aws-prd" {
  source     = "../../infraestrutura"
  imagem     = "ami-00874d747dde814fa"
  instancia  = "t2.micro"
  regiao_aws = "us-east-1"
  chave      = "IaC-PRD"
  tagName    = "Terraform Ansible - Producao"
}

output "IP" {
  value = module.aws-prd.IP_Publico
}