terraform {
  required_version = "~> 1.8"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46.0"
    }
  }
}

provider "aws" {
  region  = var.bucket_region
  profile = var.aws_profile
}
