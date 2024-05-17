variable aws_profile {}
variable bucket_name {}
variable bucket_force_destroy {}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name = var.aws_profile
  }

  force_destroy = var.bucket_force_destroy
  
  # lifecycle {
  #   prevent_destroy = true
  # }
}