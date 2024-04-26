
data "aws_iam_policy" "iam_policy_AWSLambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "iam_policy_AWSLambdaBasicExecutionRole" {
  name   = "${var.function_name}-lambda-service-role"
  policy = data.aws_iam_policy.iam_policy_AWSLambdaBasicExecutionRole.policy
}

resource "aws_iam_role" "iam_role_for_lambda" {
  name = "terraform_${var.function_name}_iam_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_AWSLambdaBasicExecutionRole.arn
}

resource "aws_cloudwatch_log_group" "cloudwatch_log" {
  name = "/aws/lambda/${var.function_name}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# lambda用Roleの設定
# resource "aws_iam_role" "lambda_iam_role" {
#   name = "terraform_${var.function_name}_iam_role"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# POLICY
# }

# lambda用Policyの作成
# resource "aws_iam_role_policy" "lambda_access_policy" {
#   name   = "terraform_${function_name}_access_policy"
#   role   = aws_iam_role.lambda_iam_role.id
#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "logs:CreateLogStream",
#         "logs:CreateLogGroup",
#         "logs:PutLogEvents"
#       ],
#       "Resource": "arn:aws:logs:*:*:*"
#     }
#   ]
# }
# POLICY
# }
