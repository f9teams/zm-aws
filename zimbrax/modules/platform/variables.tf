variable "r53_zone_id" {
  type = "string"
}

variable "containers" {
  type = "list"
}

data "aws_availability_zones" "available" {}

locals {
  environment  = "${terraform.workspace}"
  env_prefix_d = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}-"}"
  env_prefix_u = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}_"}"

  r53_zone_id = "${var.r53_zone_id}"
  containers  = "${var.containers}"

  availability_zones      = "${data.aws_availability_zones.available.names}"
  availability_zone_count = "${length(data.aws_availability_zones.available.names)}"

  private_subnet_ids = "${values(module.private_subnets.availability_zone_to_private_subnet_id)}"
  public_subnet_ids  = "${values(module.public_subnets.availability_zone_to_public_subnet_id)}"
}
