terraform {
  required_version = ">= 0.14.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.27.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

###############################################################################
# regionのazを全部取ってくるためのdata
###############################################################################
data "aws_availability_zones" "available" {}

###############################################################################
# Local data
###############################################################################
locals {
  base_name    = "test-batch"
  cluster_name = "${local.base_name}-cluster"
}

###############################################################################
# VPC
# 課金箇所：なし
###############################################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"

  name = "${local.base_name}-vpc"
  cidr = "10.0.0.0/16"
  azs  = data.aws_availability_zones.available.names
  public_subnets = [
    "10.0.0.0/24",
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
  create_database_subnet_group = false
  enable_dns_hostnames         = true
  enable_dns_support           = true
  enable_vpn_gateway           = false
  tags = {
    Owner       = "suna"
    Environment = "development"
  }
}
