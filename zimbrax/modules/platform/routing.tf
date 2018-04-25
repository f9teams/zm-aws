resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.blockchain.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.blockchain.id}"
  }

  tags {
    Name        = "${local.environment}_rt_public"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_internet_gateway" "blockchain" {
  vpc_id = "${aws_vpc.blockchain.id}"

  tags {
    Name        = "${local.environment}_igw_blockchain"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
