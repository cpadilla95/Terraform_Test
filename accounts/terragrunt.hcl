locals {
  profile                    = "test_profile"
  terraform_version          = "1.1.7"

  account_vars = read_terragrunt_config(
    "${get_parent_terragrunt_dir()}/${get_env("ACCOUNT", "")}/common.hcl",
    { inputs = {} }
  )
}

remote_state {
  backend = "s3"

  config = {
    bucket         = local.account_vars.locals["state_bucket"]
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.account_vars.locals["state_region"]
    dynamodb_table = local.account_vars.locals["state_dynamodb_table"]
    encrypt        = true
  }
}

terraform {
  extra_arguments "aws_profile" {
    commands = get_terraform_commands_that_need_vars()
    env_vars = {
      AWS_PROFILE = local.profile,
      AWS_REGION = local.account_vars.locals["state_region"]
    }
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region = local.account_vars.locals["state_region"]
}
EOF
}
