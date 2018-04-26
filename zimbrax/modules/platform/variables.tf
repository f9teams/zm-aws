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
}
