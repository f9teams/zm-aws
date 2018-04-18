provider "aws" {
  profile = "synacor"
  region  = "us-east-2"
}

data "terraform_remote_state" "base" {
  backend = "s3"

  config {
    profile              = "synacor"
    workspace_key_prefix = "workspace"
    bucket               = "zm-tf-state"
    key                  = "base.tfstate"
    region               = "us-east-1"
  }
}
