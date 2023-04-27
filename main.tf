# ---> Terraform Version and Provider <---
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.16"
    }
  }
  required_version = ">= 1.4.0"
}


# ---> Provider <---
provider "aws" {
  region = "us-east-2"
}


# ---> Variables <---
variable "InstanceTag" {
  type    = string
  default = "Terraform-TM"
}



# ---> Resources <---
resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http"
  description = "Allow http inbound traffic"




  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "http"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "allow_http_ssh"
  }
}
resource "aws_instance" "Ec2instance" {
  ami                    = "ami-0578f2b35d0328762"
  key_name               = "cloud"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
  depends_on             = [aws_security_group.allow_http_ssh]
  user_data              = file("bash.sh")
  tags = {
    name = var.InstanceTag
  }
}

#--------------> outputs <-----------
output "Ec2-instance-ID" {
  value       = aws_instance.Ec2instance.id
  description = "Aws Instance ID"
  depends_on  = [aws_instance.Ec2instance]
}
output "Ec2-instance-name" {
  value       = var.InstanceTag
  description = "Aws Instance name"
}
output "Ec2-instance-public-ip" {
  value       = aws_instance.Ec2instance.public_ip
  description = "Aws Instance public_ip"
