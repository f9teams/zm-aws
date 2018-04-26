resource "aws_subnet" "public" {
  count = "${local.availability_zone_count}"

  vpc_id            = "${local.vpc_id}"
  cidr_block        = "${cidrsubnet(local.vpc_cidr_block, 8, count.index)}"
  availability_zone = "${element(local.availability_zones, count.index)}"

  tags {
    Name        = "${local.environment}_subnet_public"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
