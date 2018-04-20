terraform {
  backend "s3" {
    profile = "synacor"
    region  = "us-east-1"
    bucket  = "zm-tf-state"
    key     = "common.tfstate"

    # dynamodb_table = "terraform-lock"
  }
}
