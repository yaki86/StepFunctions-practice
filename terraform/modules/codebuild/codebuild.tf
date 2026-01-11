resource "aws_codebuild_project" "sfn" {
  name         = "${var.env}-${var.prj}-codebuild"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }
  source {
    type            = "GITHUB"
    location        = "https://github.com/yaki86/StepFunctions-practice.git"
    git_clone_depth = 1
    buildspec       = file("${path.module}/buildspec.json")
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.env}-${var.prj}-codebuild"
      status      = "ENABLED"
      stream_name = "${var.env}-${var.prj}"
    }
  }
}
