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
  availability_zones = ["${var.regiao_aws}a", "${var.regiao_aws}a"]
  name               = var.nomeGrupoAS
  max_size           = var.maximoGrupoAS
  min_size           = var.minimoGrupoAS
  launch_template {
    id      = aws_launch_template.maquina.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.lb_target_group.arn]
}

resource "aws_default_subnet" "subnet_a" {
  availability_zone = "${var.regiao_aws}a"
}

resource "aws_default_subnet" "subnet_b" {
  availability_zone = "${var.regiao_aws}b"
}

resource "aws_lb" "loadBalancer" {
  internal = false
  subnets  = [aws_default_subnet.subnet_a.id, aws_default_subnet.subnet_b.id]
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "maquinasAlvo"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
}

resource "aws_default_vpc" "default" {
}

resource "aws_lb_listener" "listenerLoadBalance" {
  load_balancer_arn = aws_lb.loadBalancer.arn
  port              = "8000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

resource "aws_autoscaling_policy" "pol_autoscaling_producao" {
  name                   = "terraform-autoscaling"
  autoscaling_group_name = var.nomeGrupoAS
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}