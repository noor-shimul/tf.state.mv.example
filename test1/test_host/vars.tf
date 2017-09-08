# input vars/parameters.

variable "environment" {}

variable "vpc_subnet_id" {}

# data "terraform_remote_state" "test1" {
#   backend = "s3"

#   config = {
#     bucket = "allan-test-bucket-media-sre-2017"
#     key    = "NEW/test1/${var.environment}/us-west-1/terraform.tfstate"
#     region = "us-west-1"
#   }
# }

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}
