resource "aws_iam_role" "codepipeline" {
  name               = "${var.env}-${var.prj}-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_policy.json
}

resource "aws_iam_policy" "codepipeline" {
  name   = "${var.env}-${var.prj}-codepipeline-policy"
  policy = data.aws_iam_policy_document.codepipeline_iam_policy.json
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = aws_iam_policy.codepipeline.arn
}

data "aws_iam_policy_document" "codepipeline_iam_policy" {
  # Step Functions 実行
  statement {
    effect = "Allow"
    actions = [
      "states:DescribeStateMachine",
      "states:StartExecution",
      "states:DescribeExecution"
    ]
    resources = [
      var.stepfunctions_state_machine_arn
    ]
  }

  # CodeConnections (GitHub接続)
  statement {
    effect = "Allow"
    actions = [
      "codeconnections:UseConnection",
      "codestar-connections:UseConnection",
      "codestar-connections:PassConnection"
    ]
    resources = ["*"]
  }

  # S3アーティファクトストア
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [
      var.s3_bucket_arn,
      "${var.s3_bucket_arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "codepipeline_assume_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
