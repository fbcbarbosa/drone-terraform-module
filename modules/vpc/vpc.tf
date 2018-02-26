resource "aws_vpc" "drone" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = "true"

  tags {
    Name          = "${var.vpc_name}"
    Provisioner   = "Terraform"
  }
}
