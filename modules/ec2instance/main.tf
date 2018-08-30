/** Launch Configuration  **/

resource "aws_launch_configuration" "this_launch_config" {
  name_prefix                 = "${var.name}"
  image_id                    = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.linking_group.id}"]
  associate_public_ip_address = "${var.public_ip_required}"
  user_data                   = "${var.user_data}"

  lifecycle {
    create_before_destroy = true
  }
}

/** ASG **/

resource "aws_autoscaling_group" "this_asg" {
  name_prefix          = "${var.name}-"
  launch_configuration = "${aws_launch_configuration.this_launch_config.name}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  vpc_zone_identifier  = ["${var.az_subnets}"]
  target_group_arns    = ["${aws_lb_target_group.this_target_group.arn}"]
  health_check_type    = "ELB"

  lifecycle {
    create_before_destroy = true
  }
}

/** Linking SG + RULES **/

resource "aws_security_group" "linking_group" {
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "allow_in" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.linking_group.id}"
  source_security_group_id = "${aws_security_group.linking_group.id}"
}

resource "aws_security_group_rule" "allow_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.linking_group.id}"
}

/** ALB **/

resource "aws_lb" "this_alb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.security_groups}", "${aws_security_group.linking_group.id}"]
  subnets            = ["${var.az_subnets}"]
}

resource "aws_lb_target_group" "this_target_group" {
  name     = "${var.name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "this_listener" {
  load_balancer_arn = "${aws_lb.this_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.this_target_group.arn}"
  }
}
