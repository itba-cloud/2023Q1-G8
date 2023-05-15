module "vpc" {
  source = "./modules/vpc"
}

module "lambda" {
  source = "./modules/lambda"

  lambdas    = local.lambdas
  vpc_id     = module.vpc.vpc.id
  subnet_ids = [for s in module.vpc.vpc.subnets : s.id]
}

module "s3" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
  domain_name = var.domain_name
  CDN_OAI     = [module.cloudfront.OAI]
}

module "cloudfront" {
  source                      = "./modules/cdn"
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  bucket_id                   = module.s3.bucket_id
  bucket_name                 = module.s3.bucket_id
}
