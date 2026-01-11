resource "aws_iam_role" "codebuild" {
  name               = "${var.env}-${var.prj}-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_policy.json
}

resource "aws_iam_policy" "codebuild" {
  name   = "${var.env}-${var.prj}-codebuild-policy"
  policy = data.aws_iam_policy_document.codebuild_iam_policy.json
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild.arn
}

data "aws_iam_policy_document" "codebuild_iam_policy" {
  # CloudWatch Logs への書き込み
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:/aws/codebuild/${var.env}-${var.prj}-codebuild",
      "arn:aws:logs:*:*:log-group:/aws/codebuild/${var.env}-${var.prj}-codebuild:*"
    ]
  }

  # CodeBuild レポート機能（テスト結果など）
  statement {
    effect = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      "arn:aws:codebuild:*:*:report-group/${var.env}-${var.prj}-*"
    ]
  }
}

data "aws_iam_policy_document" "codebuild_assume_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}



/*
メリット・デメリット比較
観点	data分離	直接resource
可読性	  ✅ 高い（data が見やすい）	❌ JSONが増えると複雑
再利用性	 ✅ 同じ data を複数 resource で使える	❌ 重複が増える
保守性	  ✅ 構文チェック自動化	⚠️ JSONの形式を手動確認
依存性明示 ✅ 明確（data → resource）	⚠️ 曖昧
ファイル行数	❌ 増える（ボイラープレート）	✅ コンパクト

- ポリシードキュメントが大きく、複数のステートメントがある
- AssumeRole と Codebuild ポリシーで別々に管理したい
- 将来、同じポリシーを別の場所で参照する可能性を考慮
- 結論：小さいポリシーなら直接 resource でOK
- 大きい・複雑・再利用する場合は data で分離するのが標準的

*/
