data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../../vpc/terraform.tfstate"
  }
}

output "vpc_subnet_id" {
  value = "${data.terraform_remote_state.vpc.vpc_subnet_id}"
}

output "vpc_id" {
  value = "${data.terraform_remote_state.vpc.vpc_id}"
}
