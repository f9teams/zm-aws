terraform {
  backend "s3" {
    profile        = "synacor"
    region         = "us-east-1"
    bucket         = "zm-tf-state"
    key            = "shared.tfstate"
    dynamodb_table = "tfstate-lock"
  }
}
