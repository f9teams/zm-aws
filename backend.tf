terraform {
  backend "s3" {
    profile              = "synacor"
    bucket               = "zm-tf-state"
    workspace_key_prefix = "env"
    key                  = "zimbrax.tfstate"
    region               = "us-east-1"
  }
}
