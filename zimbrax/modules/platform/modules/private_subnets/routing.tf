resource "aws_route_table" "private" {
  count = "${local.availability_zone_count}"

  vpc_id = "${local.vpc_id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.egress.*.id, count.index)}"
  }

  tags {
    Name        = "${local.environment}_rt_private"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_route_table_association" "private" {
  count = "${local.availability_zone_count}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
