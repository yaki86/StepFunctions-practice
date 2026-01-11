module "codebuild" {
  source = "../../modules/codebuild"
  env    = local.env
  prj    = local.prj
}
