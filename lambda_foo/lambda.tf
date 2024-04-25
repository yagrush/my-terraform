# ローカルにあるlambdaのソースコード
data "archive_file" "lambda_foo" {
  type        = "zip"
  source_dir  = "./src"
  output_path = "./src/lambda_foo.zip"
}

# AWSへ作るlambda function
resource "aws_lambda_function" "lambda_foo" {
  function_name    = "lambda_foo"
  filename         = data.archive_file.lambda_foo.output_path
  source_code_hash = data.archive_file.lambda_foo.output_base64sha256
  runtime          = "python3.12"
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = "lambda_foo.handler"
}
