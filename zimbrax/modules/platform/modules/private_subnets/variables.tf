variable "vpc_id" {
  type = "string"
}

variable "vpc_cidr_block" {
  type = "string"
}

variable "availability_zone_count" {
  type = "string"
}

variable "availability_zones" {
  type = "list"
}

variable "public_subnet_ids" {
  type = "list"
}

locals {
  environment  = "${terraform.workspace}"
  env_prefix_d = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}-"}"
  env_prefix_u = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}_"}"

  vpc_id                  = "${var.vpc_id}"
  vpc_cidr_block          = "${var.vpc_cidr_block}"
  availability_zone_count = "${var.availability_zone_count}"
  availability_zones      = "${var.availability_zones}"
  public_subnet_ids       = "${var.public_subnet_ids}"
}
