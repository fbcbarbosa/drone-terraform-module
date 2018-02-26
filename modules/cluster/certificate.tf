resource "aws_acm_certificate" "drone" {
  domain_name       = "drone.${var.domain_name}"
  validation_method = "DNS"

  tags {
    Provider = "Terraform"
  }
}

resource "aws_route53_record" "cert_validation" {
  name = "${aws_acm_certificate.drone.domain_validation_options.0.resource_record_name}"
  type = "${aws_acm_certificate.drone.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.drone.id}"
  records = ["${aws_acm_certificate.drone.domain_validation_options.0.resource_record_value}"]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.drone.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}
