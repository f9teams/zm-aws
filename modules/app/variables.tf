locals {
  environment = "${terraform.workspace}"
}

variable "blockchain_vpc_id" {}
variable "blockchain_public_subnet_id" {}

locals {
  blockchain_vpc_id           = "${var.blockchain_vpc_id}"
  blockchain_public_subnet_id = "${var.blockchain_public_subnet_id}"
}
