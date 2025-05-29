terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.51.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11.0"
    }
  }
  backend "s3" {
    bucket         = "backend-058264397013"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/VPC"
}

module "jenkins" {
  source = "./modules/Jenkins"
  subnet_id = module.vpc.public-subnet-ids[0]
  sg_id = module.vpc.ec-frontend-sg-id
}

module "Kubernetes" {
  source              = "./modules/Kubernetes_cluster"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public-subnet-ids
  private_subnet_ids  = module.vpc.private-subnet-ids
  ec_frontend_sg_id   = module.vpc.ec-frontend-sg-id

  node_groups = {
    public = {
      name       = "public"
      subnet_ids = module.vpc.public-subnet-ids
    }
    private = {
      name       = "private"
      subnet_ids = module.vpc.private-subnet-ids
    }
  }
}

