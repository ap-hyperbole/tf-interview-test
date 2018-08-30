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

module "ireland_bastion" {
  providers {
    aws = "aws.ireland"
  }

  source             = "./modules/bastion"
  public_key         = "${var.public_key}"
  az_subnets         = "${module.ireland_vpc.public_subnet_ids}"
  public_ip_required = "true"
  instance_type      = "t2.small"
  ami_id             = "${var.ami_id["eu-west-1"]}"
  vpc_id             = "${module.ireland_vpc.vpc_id}"
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
  bastion_ip         = "${module.ireland_bastion.bastion_private_ip}/32"

  user_data = <<EOF
  #!/bin/sh
  yum install -y nginx java-1.8.0-openjdk.x86_64
  service nginx start
  sed -i '/listen       80 default_server;/a location /java-app { proxy_pass http://127.0.0.1:8080/; }'  /etc/nginx/nginx.conf
  mkdir -p /opt/java-app && wget -O /opt/java-app/demo-0.0.1-SNAPSHOT.jar https://github.com/sebwells/example-java-spring-boot-app/raw/master/demo-0.0.1-SNAPSHOT.jar
  java8 -jar /opt/java-app/demo-0.0.1-SNAPSHOT.jar &
  service nginx restart
EOF
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

module "us_bastion" {
  providers {
    aws = "aws.us"
  }

  source             = "./modules/bastion"
  public_key         = "${var.public_key}"
  az_subnets         = "${module.us_vpc.public_subnet_ids}"
  public_ip_required = "true"
  instance_type      = "t2.small"
  ami_id             = "${var.ami_id["us-east-1"]}"
  vpc_id             = "${module.us_vpc.vpc_id}"
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
  bastion_ip         = "${module.us_bastion.bastion_private_ip}/32"

  user_data = <<EOF
  #!/bin/sh
  yum install -y nginx java-1.8.0-openjdk.x86_64
  service nginx start
  sed -i '/listen       80 default_server;/a location /java-app { proxy_pass http://127.0.0.1:8080/; }'  /etc/nginx/nginx.conf
  mkdir -p /opt/java-app && wget -O /opt/java-app/demo-0.0.1-SNAPSHOT.jar https://github.com/sebwells/example-java-spring-boot-app/raw/master/demo-0.0.1-SNAPSHOT.jar
  java8 -jar /opt/java-app/demo-0.0.1-SNAPSHOT.jar &
  service nginx restart
EOF
}
