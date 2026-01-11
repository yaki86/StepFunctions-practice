resource "aws_lambda_function" "success" {
  function_name    = "${var.env}-${var.prj}-success"
  role             = aws_iam_role.lambda_role.arn
  filename         = data.archive_file.success.output_path
  source_code_hash = data.archive_file.success.output_base64sha256
  runtime          = "python3.12"
  handler          = "success_lambda.lambda_handler"
}

resource "aws_lambda_function" "fail" {
  function_name    = "${var.env}-${var.prj}-fail"
  role             = aws_iam_role.lambda_role.arn
  filename         = data.archive_file.fail.output_path
  source_code_hash = data.archive_file.fail.output_base64sha256
  runtime          = "python3.12"
  handler          = "fail_lambda.lambda_handler"
}

data "archive_file" "success" {
  type        = "zip"
  source_file = "${path.module}/source/success_lambda.py"
  output_path = "${path.module}/success_lambda.zip"
}

data "archive_file" "fail" {
  type        = "zip"
  source_file = "${path.module}/source/fail_lambda.py"
  output_path = "${path.module}/fail_lambda.zip"
}
