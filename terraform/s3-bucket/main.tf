provider "aws" {
  profile = "default"
  region  = "us-west-1"
}
resource "aws_s3_bucket" "b" {
  bucket = "${var.username}-dev-bucket"
  acl    = "private"

  tags = {
    Name = "${username} dev bucket"
    Environment = "Test/Dev/ECTECT"
  }
}