module "vpc" {
  source = "modules/vpc"

  aws_region  = "${var.aws_region}"
  vpc_name    = "${var.vpc_name}"
  az_suffixes = "${var.az_suffixes}"
  cidr_block  = "${var.cidr_block}"
}

module "cluster" {
  source = "modules/cluster"

  drone_vpc         = "${module.vpc.vpc_id}"
  drone_db_endpoint = "${module.database.drone_db_endpoint}"

  aws_region                 = "${var.aws_region}"
  domain_name                = "${var.domain_name}"
  drone_orgs                 = "${var.drone_orgs}"
  drone_open                 = "${var.drone_open}"
  drone_admin                = "${var.drone_admin}"
  drone_github_client        = "${var.drone_github_client}"
  drone_github_secret        = "${var.drone_github_secret}"
  drone_server_instance_type = "${var.drone_server_instance_type}"
  drone_agent_instance_type  = "${var.drone_agent_instance_type}"
  drone_agent_count          = "${var.drone_agent_count}"
  drone_db_password          = "${var.drone_db_password}"
}

module "database" {
  source = "modules/database"

  drone_vpc       = "${module.vpc.vpc_id}"
  drone_server_sg = "${module.cluster.drone_server_sg}"

  drone_db_password          = "${var.drone_db_password}"
  drone_storage_encrypted    = "${var.drone_storage_encrypted}"
  drone_db_instance_type     = "${var.drone_db_instance_type}"
  drone_db_allocated_storage = "${var.drone_db_allocated_storage}"
}
