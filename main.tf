terraform {
  required_version = "> 0.11.0"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_key_pair" "web" {
  public_key = "${file(pathexpand(var.public_key))}"
}

module "custom_vpc" {
  source = "./modules/vpc"

  vpc_cidr           = "${var.vpc_cidr}"
  region             = "${var.region}"
  availability_zones = "${var.availability_zones}"
}

module "web_instance" {
  source = "./modules/ec2instance"

  name               = "web-instance"
  vpc_id             = "${module.custom_vpc.vpc_id}"
  min_size           = 3
  max_size           = 5
  az_subnets         = "${module.custom_vpc.public_subnet_ids}"
  ami_id             = "${var.ami_id}"
  instance_type      = "t2.small"
  security_groups    = ["${aws_security_group.web_instance_security_group.id}"]
  key_name           = "${aws_key_pair.web.key_name}"
  public_ip_required = "true"

  user_data = <<EOF
  #!/bin/sh
  yum install -y nginx
  service nginx start
  EOF
}

resource "aws_security_group" "web_instance_security_group" {
  vpc_id = "${module.custom_vpc.vpc_id}"

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
    },
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
