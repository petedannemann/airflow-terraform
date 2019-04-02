data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
      Name = "${var.name_prefix}-vpc"
  }
}

resource "aws_subnet" "this" {
  count                   = "${var.az_count}"
  cidr_block              = "${cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id                  = "${aws_vpc.this.id}"
  map_public_ip_on_launch = true

  tags {
      Name = "${var.name_prefix}-subnet-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = "${aws_vpc.this.id}"

  tags {
      Name = "${var.name_prefix}-gateway"
  }
}

resource "aws_route_table" "this" {
  vpc_id = "${aws_vpc.this.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.this.id}"
  }

  tags {
      Name = "${var.name_prefix}-routing-table"
  }
}

resource "aws_route_table_association" "data_routing_table_association" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.this.*.id, count.index)}"
  route_table_id = "${aws_route_table.this.id}"
}

resource "aws_db_subnet_group" "this" {
  name        = "${var.name_prefix}"
  subnet_ids  = ["${aws_subnet.this.*.id}"]
}
