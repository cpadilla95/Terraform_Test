locals {
  state_bucket         = "terraform-test-cpadilla"
  state_region         = "us-east-1"
  state_dynamodb_table = "terraform_lock"
}

inputs = {
  account_id   = "1234567"
  account_name = "test"
}
