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
  region = "us-west-2"
}

resource "aws_security_group" "minecraft_sg" {
  name        = "MinecraftServerSG"
  description = "Security group for Minecraft server"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MinecraftServerSG"
  }
}

resource "aws_instance" "minecraft_server" {
  ami              = "ami-080f7286ffdf988ee"
  instance_type    = "t2.medium"
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]
  key_name         = "minecraft"

  tags = {
    Name = "MinecraftServer"
  }

  provisioner "file" {
    content     = file("MCstartup.sh")
    destination = "/home/ec2-user/MCstartup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/MCstartup.sh",
      "/home/ec2-user/MCstartup.sh"
    ]
  }
}

output "instance_public_ip" {
  value       = aws_instance.minecraft_server.public_ip
  description = "Public IP address of the instance."
}
