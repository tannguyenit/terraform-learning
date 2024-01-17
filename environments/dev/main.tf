
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }

  backend "s3" {
    bucket         = "poc-s3-backend"
    key            = "dev/main.tfstate"
    region         = "us-east-2"
    dynamodb_table = "poc-s3-backend"
    role_arn       = "arn:aws:iam::773801579928:role/PocS3BackendRole"
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "aws" {
  alias      = "cert"
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


# ============ Connection ==============
module "connection" {
  source = "../../modules/development/connection"
  name = "Github Connection"
  type = "GitHub"
}

# ============ Front end ===============
data "aws_route53_zone" "selected" {
  name         = var.route53_hosted_zone
  private_zone = var.route53_private_zone
}

module "webapp_s3" {
  source                                    = "../../modules/s3"
  bucket_name                               = var.webapp_domain_certificate
  cloudfront_origin_access_identity_iam_arn = module.webapp_origin_access_identity.cloudfront_access_identity_iam_arn
}

module "webapp_origin_access_identity" {
  source                         = "../../modules/cloudfront/origin_access_identity"
  origin_access_identity_comment = var.bucket
}

module "webapp_cloudfront_cert" {
  source                  = "../../modules/certificate"
  route53_hosted_zone     = var.route53_hosted_zone
  route53_zone_id         = data.aws_route53_zone.selected.id
  certificate_domain_name = var.webapp_domain_certificate

  providers = {
    aws = aws.cert
  }
}

module "webapp_cloudfront" {
  source                          = "../../modules/cloudfront"
  bucket_regional_domain_name     = module.webapp_s3.bucket_regional_domain_name
  alternate_domain_names          = [var.webapp_domain_certificate]
  is_webapp_distribution          = true
  cloudfront_access_identity_path = module.webapp_origin_access_identity.cloudfront_access_identity_path
  acm_certificate_arn             = module.webapp_cloudfront_cert.acm_certificate_arn
  ssl_support_method              = var.ssl_support_method
}

module "webapp_route53" {
  source          = "../../modules/route53"
  domain_name     = var.webapp_domain_certificate
  route53_zone_id = data.aws_route53_zone.selected.id
  alias_name      = module.webapp_cloudfront.domain_name
  alias_zone_id   = module.webapp_cloudfront.hosted_zone_id
}

# ==================== End front end ====================

# # ==================== Start backend ====================

locals {
  bucket_name    = "bucket-${var.project_name}-${var.env}"
  vpc_cidr_block = "10.0.0.0/16"
}

# module "app_origin_access_identity" {
#   source                         = "../../modules/cloudfront/origin_access_identity"
#   origin_access_identity_comment = "bucket-${var.project_name}-app-${var.env}"
# }

# module "app_s3" {
#   source                                    = "../../modules/s3"
#   versioning                                = var.app_bucket_versioning
#   bucket_name                               = local.bucket_name
#   cloudfront_origin_access_identity_iam_arn = module.app_origin_access_identity.cloudfront_access_identity_iam_arn
# }

# module "s3_cloudfront_cert" {
#   source                  = "../../modules/certificate"
#   route53_hosted_zone     = var.route53_hosted_zone
#   route53_zone_id         = data.aws_route53_zone.selected.id
#   certificate_domain_name = var.app_certificate_domain_name

#   providers = {
#     aws = aws.cert
#   }
# }

# module "asset_route53" {
#   source          = "../../modules/route53"
#   domain_name     = var.app_certificate_domain_name
#   route53_zone_id = data.aws_route53_zone.selected.id
#   alias_name      = module.app_cloudfront.s3_domain_name
#   alias_zone_id   = module.app_cloudfront.s3_hosted_zone_id
# }

# module "app_cloudfront" {
#   source                          = "../../modules/cloudfront"
#   bucket_regional_domain_name     = module.app_s3.bucket_regional_domain_name
#   alternate_domain_names          = [var.app_certificate_domain_name]
#   origin_shield_region            = var.aws_region
#   lambda_name                     = "lambda-edge-functions-dev-origin-response-function"
#   cloudfront_function_name        = "demo"
#   header_secret                   = "SECRET_KEY"
#   is_webapp_distribution              = false
#   cloudfront_access_identity_path = module.app_origin_access_identity.cloudfront_access_identity_path
#   ssl_support_method              = var.ssl_support_method
#   acm_certificate_arn             = module.s3_cloudfront_cert.acm_certificate_arn
# }

# module "sqs" {
#   source     = "../../modules/sqs/fifo"
#   queue_name = "sqs-${var.project_name}-${var.env}"
# }

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "${var.project_name}-${var.env}"
#   cidr = local.vpc_cidr_block

#   azs            = ["us-east-2a", "us-east-2b"]
#   public_subnets = var.public_subnets

#   tags = {
#     Environment = var.env
#     Project     = var.project_name
#   }
# }

# module "security_group" {
#   source                               = "../../modules/security_group"
#   alb_security_group_name              = "${var.project_name}-${var.env}-alb-sg"
#   alb_security_group_description       = "Security group for ALB"
#   ecs_tasks_security_group_name        = "${var.project_name}-${var.env}-container-sg"
#   ecs_tasks_security_group_description = "Security group for service container"
#   app_port                             = "80"
#   vpc_id                               = module.vpc.vpc_id
#   vpc_cidr_block                       = local.vpc_cidr_block
# }

# module "service_discovery" {
#   source = "../../modules/service_discovery"
#   private_dns_namespace = "poc.local"
#   env = var.env
#   vpc_id = module.vpc.vpc_id
# }

# # IAM
# module "ecs_iam" {
#   source = "../../modules/iam/ecs"
#   app_name = var.project_name
#   env = var.env
# }

# module "ecs_event" {
#   source = "../../modules/iam/events"
#   app_name = var.project_name
#   env = var.env
#   ecs_task_role_arn = module.ecs_iam.task_excution_role_arn
#   ecs_execution_task_role_arn = module.ecs_iam.task_excution_role_arn
#   ecs_cluster_arn = module.ecs.arn
# }

# #  END IAM
# module "ecs" {
#   source           = "../../modules/ecs"
#   ecs_cluster_name = "${var.project_name}-${var.env}-ecs-cluster"

#   tags = {
#     Environment = var.env
#     Project     = var.project_name
#     Name        = "${var.project_name}-${var.env}-ecs-cluster"
#   }
# }

# # Create cert for attach for ALB
# module "alb_cert" {
#   source                  = "../../modules/certificate"
#   route53_hosted_zone     = var.route53_hosted_zone
#   route53_zone_id         = data.aws_route53_zone.selected.id
#   certificate_domain_name = var.alb_certificate_domain_name
# }

# module "alb" {
#   source                              = "../../modules/alb"
#   name                                = "${var.project_name}-${var.env}-alb"
#   environment                         = var.env
#   alb_security_groups                 = module.security_group.alb_security_group_id
#   aws_public_subnets                  = module.vpc.public_subnets
#   vpc_id                              = module.vpc.vpc_id
#   health_check_path                   = "/health"
#   is_ssl                              = true
#   certificate_arn_attach_alb_listener = module.alb_cert.acm_certificate_arn
# }

# module "alb_route53" {
#   source          = "../../modules/route53"
#   domain_name     = var.alb_certificate_domain_name
#   route53_zone_id = data.aws_route53_zone.selected.id
#   alias_name      = module.alb.alb_dns_name
#   alias_zone_id   = module.alb.alb_zone_id
# }

# module "network" {
#   source              = "../../modules/network"
#   aws_vpc_cidr_block  = var.vpc_cidr_block
#   az_count            = var.az_count
#   vpc_name            = "vpc-${var.project_name}-${var.env}"
#   subnet_private_name = "private-subnet-${var.project_name}-${var.env}"
#   subnet_public_name  = "public-subnet-${var.project_name}-${var.env}"
# }
