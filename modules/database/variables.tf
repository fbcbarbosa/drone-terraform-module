variable "drone_vpc" {
  description = "VPC ID"
}

variable "drone_server_sg" {
  description = "Drone server security group id"
}

variable "drone_storage_encrypted" {
  description = "Database encryption at rest (minimum size db.t2.small)."
  default     = false
}

variable "drone_db_instance_type" {
  default = "db.t2.micro"
}

variable "drone_db_allocated_storage" {
  default = 10
}

variable "drone_db_password" {}
