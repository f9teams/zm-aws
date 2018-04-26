resource "aws_route_table" "public" {
  vpc_id = "${local.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${local.internet_gateway_id}"
  }

  tags {
    Name        = "${local.environment}_rt_public"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(local.availability_zones)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
