data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    profile = "synacor"
    bucket  = "zm-tf-state"
    key     = "common.tfstate"
    region  = "us-east-1"
  }
}

locals {
  blockchain_app_certificate_id   = "${data.terraform_remote_state.common.blockchain_app_certificate_id}"
  blockchain_domain_zone_id       = "${data.terraform_remote_state.common.blockchain_domain_zone_id}"
  blockchain_deployer_key_pair_id = "${data.terraform_remote_state.common.blockchain_deployer_key_pair_id}"
}