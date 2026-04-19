terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "./modules/vpc"
  project = var.project
}

module "security" {
  source = "./modules/security"

  project = var.project
  vpc_id  = module.vpc.vpc_id
}

module "rds" {
  source = "./modules/rds"

  project    = var.project
  subnet_ids = module.vpc.private_subnets
  sg_id      = module.security.rds_sg_id

  db_username = var.db_username
  db_password = var.db_password
}

module "ec2" {
  source   = "./modules/ec2"

  project   = var.project
  subnet_id = module.vpc.public_subnets[0]
  sg_id     = module.security.ec2_sg_id
  key_name  = var.key_name

  rds_endpoint = module.rds.endpoint
  db_username  = var.db_username
  db_password  = var.db_password
  s3_bucket    = module.s3.bucket_name
}

module "s3" {
  source  = "./modules/s3"
  project = var.project
}
