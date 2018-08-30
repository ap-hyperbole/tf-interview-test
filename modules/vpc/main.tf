resource "aws_vpc" "this_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
}

resource "aws_subnet" "this_public_subnet" {
  count             = "${length(var.availability_zones["${var.region}"])}"
  vpc_id            = "${aws_vpc.this_vpc.id}"
  cidr_block        = "${cidrsubnet(var.vpc_cidr, 3, count.index)}"
  availability_zone = "${element(var.availability_zones["${var.region}"], count.index)}"
}

resource "aws_route_table" "this_public_subnet_route_table" {
  vpc_id = "${aws_vpc.this_vpc.id}"
}

resource "aws_internet_gateway" "this_igw" {
  vpc_id = "${aws_vpc.this_vpc.id}"
}

resource "aws_route" "this_public_subnet_route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.this_igw.id}"
  route_table_id         = "${aws_route_table.this_public_subnet_route_table.id}"
}

resource "aws_route_table_association" "this_public_subnet_route_table_association" {
  count          = "${length(var.availability_zones["${var.region}"])}"
  subnet_id      = "${element(aws_subnet.this_public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.this_public_subnet_route_table.id}"
}
