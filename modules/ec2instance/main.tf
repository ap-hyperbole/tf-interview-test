resource "aws_instance" "this_instance" {
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids      = ["${var.security_groups}"]
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = "${var.public_ip_required}"
  key_name                    = "${var.key_name}"
  user_data                   = "${var.user_data}"
}
