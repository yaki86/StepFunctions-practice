output "codebuild_project_arn" {
  value = aws_codebuild_project.sfn.arn
}

output "codebuild_project_name" {
  value = aws_codebuild_project.sfn.name
}
