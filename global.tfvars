regions = ["eu-west-1", "us-east-1"]

vpc_cidr = {
eu-west-1 = "10.10.10.0/24"
us-east-1 = "10.10.20.0/24"
}

ami_id = {
 eu-west-1 = "ami-cdbfa4ab"
 us-east-1 = "ami-50c0ea46"
}



/** No longer required, subnets cidr carved dynamically
subnet_cidr_public = "10.10.10.0/27"
**/
