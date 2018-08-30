terraform {
  required_version = "> 0.11.0"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "ireland"
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

/**

#### Ireland Stack ####

**/

module "ireland_vpc" {
  providers {
    aws = "aws.ireland"
  }

  source = "./modules/vpc"

  vpc_cidr           = "${var.vpc_cidr["eu-west-1"]}"
  region             = "eu-west-1"
  availability_zones = "${var.availability_zones}"
}

module "ireland_web_instance" {
  providers {
    aws = "aws.ireland"
  }

  source = "./modules/ec2instance"

  name               = "web-instance"
  public_key         = "${var.public_key}"
  vpc_id             = "${module.ireland_vpc.vpc_id}"
  min_size           = "${length(var.availability_zones["eu-west-1"])}"
  max_size           = "${length(var.availability_zones["eu-west-1"]) + 2}"
  az_subnets         = "${module.ireland_vpc.public_subnet_ids}"
  ami_id             = "${var.ami_id["eu-west-1"]}"
  instance_type      = "t2.small"
  public_ip_required = "true"

  user_data = <<EOF
  #!/bin/sh
  yum install -y nginx
  service nginx start
EOF
}

resource "aws_security_group" "ireland_web_instance_security_group" {
  vpc_id = "${module.ireland_vpc.vpc_id}"

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

/**

#### N. Virginia Stack ####

**/

module "us_vpc" {
  providers {
    aws = "aws.us"
  }

  source = "./modules/vpc"

  vpc_cidr           = "${var.vpc_cidr["us-east-1"]}"
  region             = "us-east-1"
  availability_zones = "${var.availability_zones}"
}

module "us_web_instance" {
  providers {
    aws = "aws.us"
  }

  source = "./modules/ec2instance"

  name               = "web-instance"
  public_key         = "${var.public_key}"
  vpc_id             = "${module.us_vpc.vpc_id}"
  min_size           = "${length(var.availability_zones["us-east-1"])}"
  max_size           = "${length(var.availability_zones["us-east-1"]) + 2}"
  az_subnets         = "${module.us_vpc.public_subnet_ids}"
  ami_id             = "${var.ami_id["us-east-1"]}"
  instance_type      = "t2.small"
  public_ip_required = "true"

  user_data = <<EOF
  #!/bin/sh
  yum install -y nginx
  service nginx start
EOF
}
