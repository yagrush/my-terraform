variable bucket_name {}
variable bucket_force_destroy {}

module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
  bucket_force_destroy = var.bucket_force_destroy
}