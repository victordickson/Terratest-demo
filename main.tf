
provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "flugel_s3" {
  bucket = ""

  tags = {
    Name  = "var.s3_name"
    Owner = "var.owner"
  }

}

# For the EC2 Instance:
resource "aws_instance" "flugel_ec2" {
  ami = var.ami_id 
  instance_type = "t2.micro"
  tags = {
    "Name" = "var.instance_name"
    Owner  = "var.owner"
  
  }
}
