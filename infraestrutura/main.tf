terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.regiao_aws
}

resource "aws_instance" "app_server" {
  ami           = var.imagem
  instance_type = var.instancia
  key_name      = var.chave

  tags = {
    Name = "Terraform Ansible Python"
    Name = var.tagName
  }
}

resource "aws_key_pair" "chaveSSH" {
  key_name   = var.chave
  public_key = file(".ssh/${var.chave}.pub")
}

output "IP_Publico" {
  value = aws_instance.app_server.public_ip
}