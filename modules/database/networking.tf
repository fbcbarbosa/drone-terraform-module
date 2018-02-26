data "aws_vpc" "drone" {
  id = "${var.drone_vpc}"
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.drone.id}"

  tags {
    Tier = "Private"
  }
}

resource "aws_db_subnet_group" "drone" {
  name_prefix = "drone"
  subnet_ids  = ["${data.aws_subnet_ids.private.ids}"]

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "drone-db"
    Provisioner = "Terraform"
  }
}

resource "aws_security_group" "mysql_db" {
  name_prefix = "drone-mysql-db"
  description = "Configuration for a Drone MYSQL database"
  vpc_id      = "${data.aws_vpc.drone.id}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${var.drone_server_sg}"]
    description     = "Open MYSQL connection port to Public Webserver"
  }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  # see https://github.com/terraform-providers/terraform-provider-aws/issues/1671
  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "drone-mysql-db"
    Provisioner = "Terraform"
  }
}
