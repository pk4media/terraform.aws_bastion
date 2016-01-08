output "user" {
  value = "${var.user}"
}

output "instance_id" {
  value = "${aws_instance.bastion.instance_id}"
}

output "public_ip" {
  value = "${aws_instance.bastion.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.bastion.private_ip}"
}

output "private_key" {
  value = "${var.private_key}"
}

output "security_group_id" {
  value = "${aws_security_group.access.id}"
}
