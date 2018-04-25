variable "r53_zone_id" {
  type = "string"
}

variable "containers" {
  type = "list"
}

locals {
  environment  = "${terraform.workspace}"
  env_prefix_d = "${terraform.workspace == "prod" ? "" : terraform.workspace}-"
  env_prefix_u = "${terraform.workspace == "prod" ? "" : terraform.workspace}_"

  r53_zone_id = "${var.r53_zone_id}"
  containers  = "${var.containers}"
}
