# ローカルにあるlambdaのソースコード
data "archive_file" "lambda_foo" {
  type        = "zip"
  source_dir  = "./src"
  output_path = "./src/${var.function_name}.zip"
}

# AWSへ作るlambda function
resource "aws_lambda_function" "lambda_foo" {
  function_name    = var.function_name
  filename         = data.archive_file.lambda_foo.output_path
  source_code_hash = data.archive_file.lambda_foo.output_base64sha256
  runtime          = "python3.12"
  role             = aws_iam_role.iam_role_for_lambda.arn
  handler          = "${var.function_name}.lambda_handler"

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy,
    aws_cloudwatch_log_group.cloudwatch_log,
  ]
}
