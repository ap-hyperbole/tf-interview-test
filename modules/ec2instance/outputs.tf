output "public_dns" {
  value = "${aws_instance.this_instance.public_dns}"
}
output "public_ip" {
  value = "${aws_instance.this_instance.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.this_instance.private_ip}"
}
