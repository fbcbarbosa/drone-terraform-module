variable "aws_region" {
  default = "us-east-1"
}

variable "domain_name" {
  description = "Insert your domain name, e.g. 'mydomain.com'"
}

variable "drone_vpc" {
  description = "VPC ID"
}

variable "drone_agent_count" {
  description = "Number of Drone Agents"
  default     = 2
}

variable "drone_admin" {
  description = "comma-separated list of GitHub usernames of the Drone Admin"
}

variable "drone_orgs" {
  description = "GitHub Organization access. Leave it empty if none."
  default     = ""
}

variable "drone_open" {
  description = "If false, only admin user has access."
}

variable "drone_github_client" {
  description = "GitHub OAuth Application Client ID"
}

variable "drone_github_secret" {
  description = "GitHub OAuth Application Secret"
}

variable "drone_server_instance_type" {
  default = "t2.nano"
}

variable "drone_agent_instance_type" {
  default = "t2.micro"
}

variable "drone_db_endpoint" {}
variable "drone_db_password" {}
