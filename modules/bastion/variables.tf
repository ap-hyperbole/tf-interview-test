variable "ami_id" {
  description = "AMI ID to build the instance from"
  type        = "string"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = "string"
}

variable "public_key" {
  description = "Full path to your SSH key"
  type        = "string"
}

variable "public_ip_required" {
  description = "Do you require public IP?"
  default     = "false"
  type        = "string"
}

variable "az_subnets" {
  description = "List of subnets to place EC2s in this ASG"
  type        = "list"
}

variable "vpc_id" {
  description = "VPC ID in which to this instances exists."
  type        = "string"
}
