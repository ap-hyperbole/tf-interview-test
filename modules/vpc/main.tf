resource "aws_vpc" "this_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
}

resource "aws_subnet" "this_public_subnet" {
  vpc_id            = "${aws_vpc.this_vpc.id}"
  cidr_block        = "${var.subnet_cidr_public}"
  availability_zone = "${var.region}a"
}

resource "aws_route_table" "this_public_subnet_route_table" {
  vpc_id = "${aws_vpc.this_vpc.id}"
}

resource "aws_internet_gateway" "this_igw" {
  vpc_id = "${aws_vpc.this_vpc.id}"
}

resource "aws_route" "this_public_subnet_route" {
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = "${aws_internet_gateway.this_igw.id}"
  route_table_id          = "${aws_route_table.this_public_subnet_route_table.id}"
}

resource "aws_route_table_association" "this_public_subnet_route_table_association" {
  subnet_id      = "${aws_subnet.this_public_subnet.id}"
  route_table_id = "${aws_route_table.this_public_subnet_route_table.id}"
}
