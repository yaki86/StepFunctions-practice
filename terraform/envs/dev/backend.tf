terraform {
  backend "s3" {
    bucket       = "dev-sfn-yaki86-sfn-practice"
    key          = "dev.tfstate"
    region       = "ap-northeast-1"
    use_lockfile = true
  }
}

resource "aws_s3_bucket" "state-bucket" {
  bucket = "${local.env}-${local.prj}-yaki86-sfn-practice"
}

