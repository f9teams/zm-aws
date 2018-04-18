terraform {
  backend "s3" {
    profile              = "synacor"
    workspace_key_prefix = "workspace"
    bucket               = "zm-tf-state"
    key                  = "base.tfstate"
    region               = "us-east-1"
  }
}
