resource "aws_internet_gateway" "blockchain" {
  vpc_id = "${aws_vpc.blockchain.id}"

  tags {
    Name        = "${local.environment}_igw_blockchain"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
