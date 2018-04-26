resource "aws_subnet" "private" {
  count = "${local.availability_zone_count}"

  vpc_id            = "${local.vpc_id}"
  cidr_block        = "${cidrsubnet(local.vpc_cidr_block, 8, count.index + 128)}"
  availability_zone = "${element(local.availability_zones, count.index)}"

  tags {
    Name        = "${local.environment}_subnet_private"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
