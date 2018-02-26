resource "aws_security_group" "drone_lb" {
  name_prefix = "drone-lb"
  description = "Configuration for a Drone LB"
  vpc_id      = "${data.aws_vpc.drone.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Open HTTPS port"
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
    Name        = "drone-lb"
    Provisioner = "Terraform"
  }
}

resource "aws_security_group" "drone_server" {
  name_prefix = "drone-server"
  description = "Configuration for a Drone server"
  vpc_id      = "${data.aws_vpc.drone.id}"

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Open webserver port"
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Open agent communication port"
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
    Name        = "drone-server"
    Provisioner = "Terraform"
  }
}

resource "aws_security_group" "drone_agent" {
  name_prefix = "drone-agent"
  description = "Configuration for a Drone agent"
  vpc_id      = "${data.aws_vpc.drone.id}"

  // open all TCP high ports (required for server->agent communication)
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 1024
    to_port     = 65535
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
    Name        = "drone-agent"
    Provisioner = "Terraform"
  }
}
