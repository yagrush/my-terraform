data "aws_iam_policy_document" "eventbridge_scheduler_assume_policy_foo" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "scheduler.amazonaws.com",
      ]
    }
  }
}
# EventBridgeからlambda関数をキックするための権限
resource "aws_iam_role" "evnetbridge_scheduler_foo" {
  name = "${var.aws_profile}-evnetbridge-scheduler-role-foo"
  assume_role_policy = data.aws_iam_policy_document.eventbridge_scheduler_assume_policy_foo.json
  inline_policy {
    name = "${var.aws_profile}-evnetbridge-scheduler-role-inline-policy-foo"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "lambda:InvokeFunction",
          ]
          Effect = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_scheduler_schedule" "scheduler_foo" {
  name = "${var.aws_profile}-scheduler-foo"
  state = "ENABLED"

  # lambda関数実行スケジュール
  # cronの ? は "曜日"（AWSのcron独自記法）
  schedule_expression = "cron(*/1 * * * ? *)"
  schedule_expression_timezone = "Asia/Tokyo"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn = aws_lambda_function.foo.arn
    role_arn = aws_iam_role.evnetbridge_scheduler_foo.arn

    # lambda関数実行時にpythonプログラムに渡すパラメータ
    input = jsonencode({
      "name": "fugafuga"
    })
  }
}