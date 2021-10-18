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
  instance_type          = "t2.micro"
  tags = {
    "Name" = "Flugel"
    Owner  = "InfraTeam"
  }
}