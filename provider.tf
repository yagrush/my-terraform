variable aws_profile {}

terraform {
  required_version = "~> 1.8"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.26.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = var.aws_profile
  # profile = local.profile
}