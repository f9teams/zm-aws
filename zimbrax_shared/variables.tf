variable "user_keys" {
  type = "list"

  default = [
    "eric",
    "jose",
  ]
}

locals {
  user_keys = "${var.user_keys}"
}
