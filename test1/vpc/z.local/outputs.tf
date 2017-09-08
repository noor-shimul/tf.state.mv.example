# output vars

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "vpc_subnet_id" {
  value = "${aws_subnet.main_vpc_subnet.id}"
}
