provider "aws" {
  default_tags {
    tags = {
      Environment = "Production"
      Owner       = "DE-Team"
      Project     = "RDS Deployment"
      Managed_by  = "Terraform"
    }
  }
  region = "us-east-1"
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}