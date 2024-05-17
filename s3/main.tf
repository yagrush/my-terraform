module "s3" {
  source = "./modules/s3"
  aws_profile = var.aws_profile
  bucket_name = var.bucket_name
  bucket_force_destroy = var.bucket_force_destroy
}
