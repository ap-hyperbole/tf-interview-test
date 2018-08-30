variable "region" {}

variable "vpc_cidr" {}

variable "subnet_cidr_public" {}

# for the purpose of this exercise use the default key pair on your local system
variable "public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "ami_id" {
  default = "ami-cdbfa4ab"
}

variable "availability_zones" {
  default = {
    /** Ireland **/
    eu-west-1 = [
      "eu-west-1a",
      "eu-west-1b",
      "eu-west-1c",
    ]
  }
}
