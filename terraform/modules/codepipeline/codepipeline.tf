resource "aws_codestarconnections_connection" "github" {
  name          = "${var.env}-${var.prj}-github-connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.env}-${var.prj}-codepipeline"
  role_arn = aws_iam_role.codepipeline.arn
  artifact_store {
    location = var.s3_bucket_name
    type     = "S3"
  }
  stage {
    name = "Source"
    action {
      category         = "Source"
      name             = "connect-github"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "yaki86/StepFunctions-practice"
        BranchName       = "main"
      }
    }
  }
  stage {
    name = "Build"
    action {
      category        = "Invoke"
      name            = "invoke-stepfunctions"
      owner           = "AWS"
      provider        = "StepFunctions"
      version         = "1"
      input_artifacts = ["source_output"]
      configuration = {
        StateMachineArn = var.stepfunctions_state_machine_arn
        InputType       = "FilePath"
        Input           = "terraform/modules/codepipeline/stepfunctions-input.json"
      }
    }
  }

}
