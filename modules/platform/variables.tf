locals {
  environment  = "${terraform.workspace}"
  env_prefix_d = "${terraform.workspace == "prod" ? "" : terraform.workspace}-"
  env_prefix_u = "${terraform.workspace == "prod" ? "" : terraform.workspace}_"
}
