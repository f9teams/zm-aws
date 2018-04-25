variable "vpc_id" {
  type = "string"
}

variable "public_subnet_ids" {
  type = "list"
}

variable "private_subnet_ids" {
  type    = "list"
  default = []
}

variable "deployer_key_pair_id" {
  type = "string"
}

variable "user_public_keys" {
  type = "list"
}

variable "r53_zone_id" {
  type = "string"
}

variable "file_system" {
  type = "map"
}

locals {
  environment  = "${terraform.workspace}"
  env_prefix_d = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}-"}"
  env_prefix_u = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}_"}"

  vpc_id                        = "${var.vpc_id}"
  public_subnet_ids             = "${var.public_subnet_ids}"
  private_subnet_ids            = "${var.private_subnet_ids}"
  deployer_key_pair_id          = "${var.deployer_key_pair_id}"
  user_public_keys              = "${var.user_public_keys}"
  r53_zone_id                   = "${var.r53_zone_id}"
  file_system_id                = "${lookup(var.file_system, "id")}"
  file_system_security_group_id = "${lookup(var.file_system, "security_group_id")}"
}
