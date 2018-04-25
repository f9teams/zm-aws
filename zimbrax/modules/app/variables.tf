variable "vpc_id" {
  type = "string"
}

variable "r53_zone_id" {
  type = "string"
}

variable "public_subnet_ids" {
  type = "list"
}

variable "app_certificate_id" {
  type = "string"
}

variable "app_instance_ids" {
  type = "list"
}

variable "swarm_security_group_id" {
  type = "string"
}

locals {
  environment  = "${terraform.workspace}"
  env_prefix_d = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}-"}"
  env_prefix_u = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}_"}"

  vpc_id = "${var.vpc_id}"

  r53_zone_id = "${var.r53_zone_id}"

  public_subnet_ids  = "${var.public_subnet_ids}"
  app_certificate_id = "${var.app_certificate_id}"
  app_instance_ids   = "${var.app_instance_ids}"

  swarm_security_group_id = "${var.swarm_security_group_id}"
}
