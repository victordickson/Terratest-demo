terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 0.14"

  backend "remote" {
    organization = "hustler"

    workspaces {
      name = "hustler-dev"
    }
  }
}


provider "aws" {
  region = "us-west-1"
}


resource "aws_s3_bucket" "flugel_s3" {
  bucket = "flugel-bucket"

  # Enable versioning to see our statefile history.
  versioning {
    enabled = true
  }

  # Enable serverside encryption by default.
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name  = "Flugel"
    Owner = "InfraTeam"
  }

}

# For the EC2 Instance:
resource "aws_instance" "flugel_EC2" {
  # Run an Ubuntu 18.04 AMI on the EC2 instance.
  ami                    = "ami-07b068f843ec78e72"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.flugelSG.id]
  tags = {
    "Name" = "Flugel"
    Owner  = "InfraTeam"
  }
  user_data = <<EOF
  #!/bin/bash
  echo "Hello World!" > index.html
  nohup busybox httpd -f -p 8080 &
  EOF
}

resource "aws_security_group" "flugelSG" {
  name = "infraTeam"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Flugel"
    Owner = "InfraTeam"
  }
}

output "public_ip" {
  value = aws_instance.flugel_EC2.public_ip
}