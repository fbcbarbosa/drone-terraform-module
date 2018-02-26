##############################
### PROVIDER CONFIGURATION ###
##############################
variable "aws_region" {
  default = "us-east-1"
}

##################################
### DISTRIBUTION CONFIGURATION ###
##################################

variable "domain_name" {
  description = "Insert your domain name, e.g. 'mydomain.com'"
}

#########################
### VPC CONFIGURATION ###
#########################

variable "vpc_name" {
  description = "VPC Name"
  default     = "drone"
}

variable "az_suffixes" {
  description = "Create subnets in these availability zones"
  type        = "list"
}

variable "cidr_block" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

###########################
### DRONE CONFIGURATION ###
###########################

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

