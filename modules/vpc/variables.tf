variable "region" {}

variable "cidr_block" {
  default = "10.0.0.0/16"
  type    = string
}

variable "availability_zones" {
  type = list(string)
}