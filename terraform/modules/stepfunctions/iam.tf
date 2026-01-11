resource "aws_iam_role_policy_attachment" "stepfunctions" {
  role       = aws_iam_role.stepfunctions.name
  policy_arn = aws_iam_policy.stepfunctions.arn
}

resource "aws_iam_role" "stepfunctions" {
  name               = "${var.env}-${var.prj}-stepfunctions-role"
  assume_role_policy = data.aws_iam_policy_document.stepfunctions_assume_role.json
}

resource "aws_iam_policy" "stepfunctions" {
  name   = "${var.env}-${var.prj}-stepfunctions-policy"
  policy = data.aws_iam_policy_document.stepfunctions_iam_policy.json
}

data "aws_iam_policy_document" "stepfunctions_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}


data "aws_iam_policy_document" "stepfunctions_iam_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "logs:CreateLogDelivery",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutLogEvents",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups"
    ]
  }

  statement {
    effect    = "Allow"
    resources = [var.codebuild_project_arn]
    actions = [
      "codebuild:StartBuild",
      "codebuild:StopBuild",
      "codebuild:BatchGetBuilds"
    ]
  }
}
