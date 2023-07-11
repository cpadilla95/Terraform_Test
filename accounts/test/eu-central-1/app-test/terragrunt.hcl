include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//modules/app"
}

inputs = {
  warmup   = 300
  cooldown = 100
}