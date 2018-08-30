# VPC Module

Simple VPC  module.
The module will create required number of subnets across multiple AZs,
routing table and Internet Gateway.
Region is parameterised.

# Eample Usage
```
module "custom_vpc" {
  source = "./modules/vpc"

  vpc_cidr           = "${var.vpc_cidr}"
  region             = "${var.region}"
  availability_zones = "${var.availability_zones}"
}
```
