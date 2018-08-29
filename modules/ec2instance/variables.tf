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
variable "subnet_id" {
  description = "Subnet ID in which to place this instance."
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
  /**
  It is recommended for now to specify boolean values for variables as the strings "true" and "false", to avoid some caveats in the conversion process.
  A future version of Terraform will properly support boolean values and so relying on the current behavior could result in backwards-incompatibilities at that time.
  **/
  type        = "string"
}
