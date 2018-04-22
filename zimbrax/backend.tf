terraform {
  backend "s3" {
    profile              = "synacor"
    region               = "us-east-1"
    bucket               = "zm-tf-state"
    workspace_key_prefix = "env"
    key                  = "zimbrax.tfstate"
    dynamodb_table       = "tfstate-lock"
  }
}
