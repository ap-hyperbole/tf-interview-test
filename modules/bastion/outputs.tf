output "bastion_public_ip" {
  value = "${aws_instance.this_instance.public_ip}"
}

output "bastion_private_ip" {
  value = "${aws_instance.this_instance.private_ip}"
}
