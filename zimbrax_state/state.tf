resource "aws_s3_bucket" "tfstate" {
  bucket = "zm-tf-state"

  versioning {
    enabled = true
  }

  tags {
    Name    = "bucket_tfstate"
    Project = "blockchain"
  }
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name           = "tfstate-lock"
  read_capacity  = "2"
  write_capacity = "2"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name    = "table_tfstate_lock"
    Project = "blockchain"
  }
}
