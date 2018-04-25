resource "aws_vpc" "blockchain" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name        = "${local.environment}_vpc_blockchain"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.blockchain.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags {
    Name        = "${local.environment}_subnet_public"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.blockchain.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2a"

  tags {
    Name        = "${local.environment}_subnet_private"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
