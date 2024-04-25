variable bucket_name {}
variable bucket_force_destroy {}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name = "hogehoge"
  }

  force_destroy = var.bucket_force_destroy
}