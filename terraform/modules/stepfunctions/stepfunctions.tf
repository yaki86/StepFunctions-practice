resource "aws_sfn_state_machine" "sfn" {
  name     = "${var.env}-${var.prj}-state-machine"
  role_arn = aws_iam_role.stepfunctions.arn

  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.stepfunctions.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }

  definition = templatefile("${path.module}/state.json", {
    codebuild_project_name = var.codebuild_project_name
  })

}

resource "aws_cloudwatch_log_group" "stepfunctions" {
  name              = "/aws/states/${var.env}-${var.prj}-stepfunctions"
  retention_in_days = 7
}
