# terraformで直接S3にファイルをアップロードするテスト（特に意味はない）
resource "aws_s3_object" "upload_initial_files" {
  bucket = var.bucket_name

  for_each = fileset("${path.root}/${var.function_name}/upload_test_files/", "*")
  key = "${each.value}"
  source = "${path.root}/${var.function_name}/upload_test_files/${each.value}"
  etag = filemd5("${path.root}/${var.function_name}/upload_test_files/${each.value}")
}
