variable "aws_profile" {
  type = string
  default = "default"
}

variable "bucket_name" {
  type = string
}
variable "bucket_region" {
  type = string
  default = "ap-northeast-1"
}
variable "function_name" {
  type = string
}