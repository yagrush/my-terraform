variable aws_profile {}
variable bucket_name {}

terraform {
  backend "s3" {
    region = "ap-northeast-1"
    bucket = var.bucket_name
    # key = "terraform.tfstate"
    # lock_table = "terraform-state-lock"
    profile = var.aws_profile
    encrypt  = true
  }
}