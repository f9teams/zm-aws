resource "aws_vpc" "blockchain" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name      = "${terraform.workspace}_vpc_blockchain"
    Workspace = "${terraform.workspace}"
    Project   = "blockchain"
  }
}

output "blockchain_vpc_id" {
  value = "${aws_vpc.blockchain.id}"
}

resource "aws_subnet" "blockchain_public" {
  vpc_id            = "${aws_vpc.blockchain.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags {
    Name      = "${terraform.workspace}_subnet_blockchain_public"
    Workspace = "${terraform.workspace}"
    Project   = "blockchain"
  }
}

output "blockchain_public_subnet_id" {
  value = "${aws_subnet.blockchain_public.id}"
}

resource "aws_subnet" "blockchain_private" {
  vpc_id            = "${aws_vpc.blockchain.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2a"

  tags {
    Name      = "${terraform.workspace}_subnet_blockchain_private"
    Workspace = "${terraform.workspace}"
    Project   = "blockchain"
  }
}

resource "aws_route_table" "blockchain_public" {
  vpc_id = "${aws_vpc.blockchain.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.blockchain.id}"
  }

  tags {
    Name      = "${terraform.workspace}_rt_blockchain_public"
    Workspace = "${terraform.workspace}"
    Project   = "blockchain"
  }
}

resource "aws_route_table_association" "blockchain_public" {
  subnet_id      = "${aws_subnet.blockchain_public.id}"
  route_table_id = "${aws_route_table.blockchain_public.id}"
}

resource "aws_internet_gateway" "blockchain" {
  vpc_id = "${aws_vpc.blockchain.id}"

  tags {
    Name      = "${terraform.workspace}_igw_blockchain"
    Workspace = "${terraform.workspace}"
    Project   = "blockchain"
  }
}
