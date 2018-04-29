variable "db_password" {
  type    = "string"
  default = "yC;6#YM8XB^9kWg4"
}

locals {
  db_password = "${var.db_password}"
}
