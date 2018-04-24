variable "user_keys" {
  type = "list"
}

locals {
  user_keys = "${var.user_keys}"
}
