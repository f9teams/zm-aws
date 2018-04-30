variable "vpc_id" {
  type = "string"
}

variable "public_subnet_id" {
  type = "string"
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

variable "file_system_id" {
  type = "string"
}

variable "file_system_security_group_id" {
  type = "string"
}

variable "cache_security_group_id" {
  type = "string"
}

variable "db_security_group_id" {
  type = "string"
}

variable "db_fqdn" {
  type = "string"
}

variable "swarm_security_group_id" {
  type = "string"
}

locals {
  environment  = "${terraform.workspace}"
  env_prefix_d = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}-"}"
  env_prefix_u = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}_"}"

  vpc_id           = "${var.vpc_id}"
  public_subnet_id = "${var.public_subnet_id}"

  deployer_key_pair_id = "${var.deployer_key_pair_id}"
  user_public_keys     = "${var.user_public_keys}"

  r53_zone_id = "${var.r53_zone_id}"

  file_system_id                = "${var.file_system_id}"
  file_system_security_group_id = "${var.file_system_security_group_id}"

  cache_security_group_id = "${var.cache_security_group_id}"

  db_security_group_id = "${var.db_security_group_id}"
  db_fqdn              = "${var.db_fqdn}"

  swarm_security_group_id = "${var.swarm_security_group_id}"
}
