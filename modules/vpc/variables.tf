variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_name" {
  description = "VPC Name"
}

variable "az_suffixes" {
  description = "Create subnets in these availability zones"
  type        = "list"
}

variable "cidr_block" {
  description = "VPC CIDR block"
}
