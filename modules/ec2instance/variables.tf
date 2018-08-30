variable "name" {
  description = "Name that will be prefixed across all resources in this module"
  type        = "string"
}

variable "ami_id" {
  description = "AMI ID to build the instance from"
  type        = "string"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = "string"
}

variable "security_groups" {
  description = "List of secuirty groups to associate with this instance"
  type        = "list"
}

variable "vpc_id" {
  description = "VPC ID in which to this instances exists."
  type        = "string"
}

variable "key_name" {
  description = "SSH key name to assign to this instance."
  type        = "string"
}

variable "user_data" {
  description = "Bootstrap commands"
  type        = "string"
}

variable "public_ip_required" {
  description = "Do you require public IP?"
  default     = "false"
  type        = "string"
}

variable "min_size" {
  description = "Autoscaling Group min number of instances"
  default     = "1"
  type        = "string"
}

variable "max_size" {
  description = "Autoscaling Group max number of instances"
  default     = "3"
  type        = "string"
}

variable "az_subnets" {
  description = "List of subnets to place EC2s in this ASG"
  type        = "list"
}
