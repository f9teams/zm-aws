module "public_subnets" {
  source = "./modules/public_subnets"

  vpc_id                  = "${aws_vpc.blockchain.id}"
  vpc_cidr_block          = "${aws_vpc.blockchain.cidr_block}"
  availability_zone_count = "${local.availability_zone_count}"
  availability_zones      = "${local.availability_zones}"
  internet_gateway_id     = "${aws_internet_gateway.blockchain.id}"
}

module "private_subnets" {
  source = "./modules/private_subnets"

  vpc_id                  = "${aws_vpc.blockchain.id}"
  vpc_cidr_block          = "${aws_vpc.blockchain.cidr_block}"
  availability_zone_count = "${local.availability_zone_count}"
  availability_zones      = "${local.availability_zones}"
  public_subnet_ids       = "${values(module.public_subnets.availability_zone_to_public_subnet_id)}"
}
