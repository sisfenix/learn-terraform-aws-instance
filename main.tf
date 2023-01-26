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
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-00874d747dde814fa"
  instance_type = "t2.micro"
  key_name = "IaC-AWS"

  user_data = <<-EOF
    #! /bin/bash
    cd /home/ubuntu/
    echo "<h1>Deploy via terraform</h1>" > index.html
    nohup busybox httpd -f -p 8080 &
  EOF
  user_data_replace_on_change = true

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
