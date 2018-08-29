terraform {
  required_version = "> 0.11.0"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_key_pair" "web" {
  public_key = "${file(pathexpand(var.public_key))}"
}

module "ireland_vpc" {
  source             = "./modules/vpc"

  vpc_cidr           = "${var.vpc_cidr}"
  subnet_cidr_public = "${var.subnet_cidr_public}"
  region             = "${var.region}"
}

module "web_instance" {
  source = "./modules/ec2instance"

  ami_id = "${var.ami_id}"
  instance_type = "t2.small"
  security_groups = [ "${aws_security_group.web_instance_security_group.id}" ]
  subnet_id = "${module.ireland_vpc.public_subnet_id}"
  key_name = "${aws_key_pair.web.key_name}"
  public_ip_required = "true"
  user_data = <<EOF
  #!/bin/sh
  yum install -y nginx
  service nginx start
  EOF
}

resource "aws_security_group" "web_instance_security_group" {
  vpc_id      = "${module.ireland_vpc.vpc_id}"

  ingress = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
