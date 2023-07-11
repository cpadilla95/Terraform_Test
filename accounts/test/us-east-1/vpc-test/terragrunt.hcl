include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//modules/vpc"
}

inputs = {
  availability_zones = [ "us-east-1a", "us-east-1b" ]
}