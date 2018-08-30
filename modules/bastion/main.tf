resource "aws_instance" "this_instance" {
  ami                         = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${aws_security_group.this_instance_security_group.id}"]
  subnet_id                   = "${var.az_subnets[0]}"
  associate_public_ip_address = "${var.public_ip_required}"
  key_name                    = "${aws_key_pair.this_key.key_name}"
}

resource "aws_security_group" "this_instance_security_group" {
  vpc_id = "${var.vpc_id}"

  ingress = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "this_key" {
  public_key = "${file(pathexpand(var.public_key))}"
}
