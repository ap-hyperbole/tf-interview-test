variable "enable_dns_hostnames" {
  description = "DNS hostnames support within VPC"
  default     = "true"
  type        = "string"
}

variable "vpc_cidr" {
  description = "CIDR range for this VPC. Example : 10.10.10.0/24"
  type        = "string"
}

variable "region" {
  description = "AWS region in which this VPC will be created. Example : eu-west-1"
  type        = "string"
}

variable "availability_zones" {
  description = "Map of AZs"
  type        = "map"
}
