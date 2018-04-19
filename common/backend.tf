terraform {
  backend "s3" {
    profile = "synacor"
    bucket  = "zm-tf-state"
    key     = "common.tfstate"
    region  = "us-east-1"
  }
}
