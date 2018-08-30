# EC2 Instance Module

Simple module to create resilient EC2 instances deployed across multiple AZs,
with auto-healing provided by ALB and ASG.
The module will create Launch Configuration with customisable UserData, ASG and ALB.
ASG will autoassociate instances with the ALB and health check on http://${instance}/

# Eample Usage

```
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
  public_ip_required = "false"

  user_data = <<EOF
  #!/bin/sh
  yum install -y nginx
  service nginx start
  EOF
}
```
