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

resource "aws_launch_template" "maquina" {
  image_id      = var.imagem
  instance_type = var.instancia
  key_name      = var.chave

  tags = {
    Name = var.tagName
  }

  security_group_names = [var.grupoDeSeguraca]
  user_data            = filebase64("./ansible.sh")

}

resource "aws_key_pair" "chaveSSH" {
  key_name   = var.chave
  public_key = file(".ssh/${var.chave}.pub")
}

output "IP_Publico" {
  value = "corrigir" #aws_instance.maquina.public_ipblic_ip
}

resource "aws_autoscaling_group" "grupoAS" {
  availability_zones = ["${var.regiao_aws}a"]
  name               = var.nomeGrupoAS
  max_size           = var.maximoGrupoAS
  min_size           = var.minimoGrupoAS
  launch_template {
    id      = aws_launch_template.maquina.id
    version = "$Latest"
  }
}