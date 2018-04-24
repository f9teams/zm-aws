variable "user_keys" {
  type = "list"

  default = [
    "eric",
  ]
}

locals {
  user_keys = "${var.user_keys}"
}
