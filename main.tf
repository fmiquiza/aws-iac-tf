terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "aws-sd2026-bucket"
    key    = "student-app/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Obtener la AMI más reciente de Amazon Linux 2023 automáticamente
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# 2. Grupo de Seguridad (Puerto 8000 HTTP y Puerto 22 SSH)
resource "aws_security_group" "web_sg" {
  name        = "student-day-terraform-sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    description = "HTTP Public Access"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Puedes restringirlo a tu IP por seguridad
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Instancia EC2 y Script de Inicialización (UserData)
resource "aws_instance" "web" {
  # ami                    = data.aws_ssm_parameter.al2023.value
  ami                    = "ami-0d27e0fb3bac4d724"
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nodejs git

              mkdir -p /var/www/app
              cd /var/www/app
              git clone ${var.github_repo_url} .
              npm install

              cat <<EOT > /etc/systemd/system/nodeapp.service
              [Unit]
              Description=Node.js Web App (Terraform)
              After=network.target

              [Service]
              Type=simple
              User=root
              WorkingDirectory=/var/www/app
              ExecStart=/usr/bin/node server.js
              Restart=always

              [Install]
              WantedBy=multi-user.target
              EOT

              systemctl daemon-reload
              systemctl enable nodeapp
              systemctl start nodeapp
              EOF

  tags = {
    Name = "StudentDay-Terraform-EC2"
  }
}