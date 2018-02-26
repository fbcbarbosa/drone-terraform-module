provider "aws" {
  version = "~> 1.9"
  region  = "${var.aws_region}"
}

terraform {
  backend "local" {}
}
