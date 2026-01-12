module "codepipeline" {
  source                          = "../../modules/codepipeline"
  env                             = local.env
  prj                             = local.prj
  stepfunctions_state_machine_arn = module.stepfunctions.stepfunctions_state_machine_arn
  s3_bucket_arn                   = module.s3.s3_bucket_arn
  s3_bucket_name                  = module.s3.s3_bucket_name
}

module "codebuild" {
  source = "../../modules/codebuild"
  env    = local.env
  prj    = local.prj
}

module "stepfunctions" {
  source                 = "../../modules/stepfunctions"
  env                    = local.env
  prj                    = local.prj
  codebuild_project_name = module.codebuild.codebuild_project_name
  codebuild_project_arn  = module.codebuild.codebuild_project_arn
}

module "lambda" {
  source = "../../modules/lambda"
  env    = local.env
  prj    = local.prj
}

module "s3" {
  source = "../../modules/s3"
  env    = local.env
  prj    = local.prj
}
