resource "aws_subnet" "public" {
  count             = "${length(var.az_suffixes)}"
  vpc_id            = "${aws_vpc.drone.id}"
  availability_zone = "${var.aws_region}${element(var.az_suffixes, count.index)}"
  cidr_block        = "${cidrsubnet(aws_vpc.drone.cidr_block, 8, count.index)}"

  tags {
    Name          = "public-${element(var.az_suffixes, count.index)}"
    Tier          = "Public"
    Provisioner   = "Terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.drone.id}"

  tags {
    Name          = "${var.vpc_name}"
    Provisioner   = "Terraform"
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = "${aws_vpc.drone.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name          = "default-public"
    Provisioner   = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.az_suffixes)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_default_route_table.main.id}"
}
