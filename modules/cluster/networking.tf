data "aws_vpc" "drone" {
  id = "${var.drone_vpc}"
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.aws_vpc.drone.id}"

  tags {
    Tier = "Private"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${data.aws_vpc.drone.id}"

  tags {
    Tier = "Public"
  }
}
