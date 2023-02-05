module "aws-dev" {
  source = "../../infraestrutura"
  imagem = "ami-00874d747dde814fa"
  instancia = "t2.micro"
  regiao_aws = "us-east-1"
  chave = "IaC-DEV"
  tagName = "Terraform Ansible - Desenv"
}