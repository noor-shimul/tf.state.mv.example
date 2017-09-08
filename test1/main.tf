#
# Global config.
terraform {
  required_version = ">= 0.9" #, < 0.10"

  #  backend          "s3"             {}
}

provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source      = "./vpc"
  environment = "${var.environment}"
  aws_region  = "${var.aws_region}"
}

module "test_host" {
  source        = "./test_host"
  environment   = "${var.environment}"
  vpc_subnet_id = "${module.vpc.vpc_subnet_id}"
}
