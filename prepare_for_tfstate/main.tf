resource "aws_s3_bucket" "tfstate" {
  bucket = var.name_terraform_state_s3_bucket

  tags = {
    Name = var.aws_profile
  }

  force_destroy = var.bucket_force_destroy
  
  # lifecycle {
  #   prevent_destroy = true
  # }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket.tfstate,
  ]
}
resource "aws_s3_account_public_access_block" "tfstate" {
  block_public_acls   = false
  block_public_policy = false

  depends_on = [
    aws_s3_bucket_public_access_block.tfstate,
  ]
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name = var.name_terraform_state_lock_dynamodb_table
  read_capacity = 1
  write_capacity = 1
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}