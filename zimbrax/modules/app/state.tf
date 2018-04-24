data "terraform_remote_state" "shared" {
  backend = "s3"

  config {
    profile = "synacor"
    bucket  = "zm-tf-state"
    key     = "shared.tfstate"
    region  = "us-east-1"
  }
}

locals {
  blockchain_app_certificate_id   = "${data.terraform_remote_state.shared.blockchain_app_certificate_id}"
  blockchain_domain_zone_id       = "${data.terraform_remote_state.shared.blockchain_domain_zone_id}"
  blockchain_deployer_key_pair_id = "${data.terraform_remote_state.shared.blockchain_deployer_key_pair_id}"
  blockchain_user_public_keys     = "${data.terraform_remote_state.shared.blockchain_user_public_keys}"
}
