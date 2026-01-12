resource "aws_s3_bucket" "s3" {
  bucket = "${var.env}-${var.prj}-yaki86-artifact-bucket"
}
