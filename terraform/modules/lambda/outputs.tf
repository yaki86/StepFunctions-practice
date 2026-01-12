output "lambda_arns" {
  value = [
    aws_lambda_function.success.arn,
    aws_lambda_function.fail.arn
  ]
}
