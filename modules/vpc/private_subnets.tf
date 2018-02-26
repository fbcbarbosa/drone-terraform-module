resource "aws_subnet" "private" {
  count             = "${length(var.az_suffixes)}"
  vpc_id            = "${aws_vpc.drone.id}"
  availability_zone = "${var.aws_region}${element(var.az_suffixes, count.index)}"
  cidr_block        = "${cidrsubnet(aws_vpc.drone.cidr_block, 8, count.index + 10)}"

  tags {
    Name          = "private-${element(var.az_suffixes, count.index)}"
    Tier          = "Private"
    Provisioner   = "Terraform"
  }
}

resource "aws_eip" "nat_eip" {
  vpc   = true
  count = "${length(var.az_suffixes)}"

  tags {
    Name          = "eip-${element(var.az_suffixes, count.index)}"
    Provisioner   = "Terraform"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = "${length(var.az_suffixes)}"
  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  depends_on = ["aws_internet_gateway.igw"]

  tags {
    Name          = "nat-${element(var.az_suffixes, count.index)}"
    Provisioner   = "Terraform"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.drone.id}"
  count  = "${length(var.az_suffixes)}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  }

  tags {
    Name          = "private-${element(var.az_suffixes, count.index)}"
    Provisioner   = "Terraform"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.az_suffixes)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
