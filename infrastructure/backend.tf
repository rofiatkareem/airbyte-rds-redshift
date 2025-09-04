terraform {
  backend "s3" {
    bucket = "ecommerce-rds"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}