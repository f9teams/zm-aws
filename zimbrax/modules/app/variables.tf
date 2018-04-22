locals {
  environment  = "${terraform.workspace}"
  env_prefix_d = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}-"}"
  env_prefix_u = "${terraform.workspace == "prod" ? "" : "${terraform.workspace}_"}"
}

variable "blockchain_vpc_id" {
  type = "string"
}

variable "blockchain_public_subnet_id" {
  type = "string"
}

variable "blockchain_fs_sg_id" {
  type = "string"
}

variable "blockchain_fs_id" {
  type = "string"
}

locals {
  blockchain_vpc_id           = "${var.blockchain_vpc_id}"
  blockchain_public_subnet_id = "${var.blockchain_public_subnet_id}"
  blockchain_fs_sg_id         = "${var.blockchain_fs_sg_id}"
  blockchain_fs_id            = "${var.blockchain_fs_id}"
}

variable "containers" {
  type = "list"
}

locals {
  containers = "${var.containers}"
}
