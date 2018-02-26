data "aws_route53_zone" "drone" {
  name         = "${var.domain_name}."
  private_zone = false
}

resource "aws_route53_record" "drone" {
  zone_id = "${data.aws_route53_zone.drone.zone_id}"
  name    = "drone.${data.aws_route53_zone.drone.name}"

  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.drone_server.dns_name}"]
}

resource "aws_route53_record" "grpc" {
  zone_id = "${data.aws_route53_zone.drone.zone_id}"
  name    = "drone.grpc.${data.aws_route53_zone.drone.name}"

  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_instance.drone_server.private_dns}"]
}
