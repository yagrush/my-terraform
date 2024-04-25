variable "aws_profile" {
  type = string
  default = "default"
}
variable "bucket_region" {
  type = string
  default = "ap-northeast-1"
}
variable "bucket_force_destroy" {
  type = bool
  default = false
}
variable "name_terraform_state_lock_dynamodb_table" {
  type = string
}
variable "name_terraform_state_s3_bucket" {
  type = string
}