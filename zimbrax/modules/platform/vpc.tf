resource "aws_vpc" "blockchain" {
  cidr_block           = "10.35.0.0/16"
  enable_dns_hostnames = true

  tags {
    Name        = "${local.environment}_vpc_blockchain"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
