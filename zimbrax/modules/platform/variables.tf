variable "availability_zones" {
  type = "list"
}

variable "r53_zone_id" {
  type = "string"
}

variable "containers" {
  type = "list"
}

variable "db_password" {
  type = "string"
}

locals {
  environment  = "${terraform.workspace}"
  env_prefix_d = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}-"}"
  env_prefix_u = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}_"}"

  r53_zone_id = "${var.r53_zone_id}"
  containers  = "${var.containers}"

  availability_zones      = "${var.availability_zones}"
  availability_zone_count = "${length(var.availability_zones)}"

  private_subnet_ids = "${values(module.private_subnets.availability_zone_to_private_subnet_id)}"
  public_subnet_ids  = "${values(module.public_subnets.availability_zone_to_public_subnet_id)}"

  db_password = "${var.db_password}"
}
