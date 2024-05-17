# ↓ zipファイルでlambda関数を登録する場合

# # ローカルにあるlambdaのソースコード
# data "archive_file" "lambda_foo" {
#   type        = "zip"
#   source_dir  = "./src"
#   output_path = "./src/${var.function_name}.zip"
# }

# # AWSへ作るlambda function
# resource "aws_lambda_function" "lambda_foo" {
#   function_name    = var.function_name
#   filename         = data.archive_file.lambda_foo.output_path
#   source_code_hash = data.archive_file.lambda_foo.output_base64sha256
#   runtime          = "python3.12"
#   role             = aws_iam_role.iam_role_for_lambda.arn
#   handler          = "${var.function_name}.lambda_handler"

#   depends_on = [
#     aws_iam_role_policy_attachment.lambda_policy,
#     aws_cloudwatch_log_group.cloudwatch_log,
#   ]
# }

# ------------------------------------------------------------------------

# ↓ ECRにdockerイメージを登録してそこからlambda関数を作成する場合

# Lambda
resource "aws_lambda_function" "foo" {
  depends_on = [
    aws_cloudwatch_log_group.lambda_foo,
    null_resource.image_push,
  ]

  function_name = var.ecr_name_foo
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.foo.repository_url}:latest"
  role          = aws_iam_role.lambda_foo.arn
  publish       = true

  memory_size = 256 # MB
  timeout     = 30 # 秒

  lifecycle {
    ignore_changes = [
      image_uri, last_modified
    ]
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_foo" {
  name               = var.ecr_name_foo
  assume_role_policy = data.aws_iam_policy_document.lambda_foo_assume.json
}

data "aws_iam_policy_document" "lambda_foo_assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_foo.name
  policy_arn = aws_iam_policy.lambda_foo_custom.arn
}
# lambda関数実行ロールの権限
resource "aws_iam_policy" "lambda_foo_custom" {
  name   = var.ecr_name_foo
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "s3:ListBucket",
        "s3:*Object"
      ],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::${var.bucket_name}/*"]
    }
  ]
}
EOF
}

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "lambda_foo" {
  name              = "/aws/lambda/${var.ecr_name_foo}"
  retention_in_days = 3
}

# Lambda Alias
resource "aws_lambda_alias" "foo_dev" {
  name             = "Dev"
  function_name    = aws_lambda_function.foo.function_name
  function_version = aws_lambda_function.foo.version

  lifecycle {
    ignore_changes = [function_version]
  }
}
