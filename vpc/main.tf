#
# Global config.
terraform {
  required_version = ">= 0.9" #, < 0.10"
}

provider "aws" {
  region = "${var.aws_region}"
}

################

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-${var.environment}-${var.aws_region}"
  }
}

resource "aws_subnet" "main_vpc_subnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.0.0/24"

  availability_zone = "us-west-1b"

  tags = {
    Name = "vpc-${var.environment}-${var.aws_region}"
  }
}
