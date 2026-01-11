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
