resource "aws_instance" "test_host" {
  ami = "${data.aws_ami.ubuntu.id}"

  #  subnet_id     = "${data.terraform_remote_state.vpc.vpc_subnet_id}"
  #  subnet_id     = "${module.vpc.vpc_subnet_id}"
  subnet_id = "${var.vpc_subnet_id}"

  instance_type = "t2.micro"

  tags {
    Name        = "test_host"
    Environment = "${var.environment}"
  }
}
