variable "region" {}

variable "port" {
  default = 80
  type    = number
}

variable "protocol" {
  default = "HTTPS"
}

variable "warmup" {
  type = number
}

variable "cooldown" {
  type = number
}