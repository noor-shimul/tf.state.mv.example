output "test_host_id" {
  value = "${aws_instance.test_host.id}"

  #  value = "${data.terraform_remote_state.test1.test_host_id}"
}
