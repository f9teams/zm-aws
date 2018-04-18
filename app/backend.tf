terraform {
  backend "s3" {
    profile              = "synacor"
    workspace_key_prefix = "workspace"
    bucket               = "zm-tf-state"
    key                  = "app.tfstate"
    region               = "us-east-1"
  }
}
