resource "aws_nat_gateway" "egress" {
  count = "${local.availability_zone_count}"

  allocation_id = "${element(aws_eip.egress_ngw.*.id, count.index)}"
  subnet_id     = "${element(local.public_subnet_ids, count.index)}"

  tags {
    Name        = "${local.environment}_ngw_blockchain"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_eip" "egress_ngw" {
  count = "${local.availability_zone_count}"
  vpc   = true
}
