resource "aws_lb" "drone_server" {
  name_prefix = "drone"
  internal    = false

  subnets            = ["${data.aws_subnet_ids.public.ids}"]
  security_groups    = ["${aws_security_group.drone_lb.id}"]
  load_balancer_type = "application"

  tags {
    Provisioner = "Terraform"
  }
}

resource "aws_lb_listener" "drone_server" {
  load_balancer_arn = "${aws_lb.drone_server.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_acm_certificate.drone.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.drone_server.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "drone_server" {
  name_prefix = "drone"
  port        = 8000

  protocol    = "HTTP"
  vpc_id      = "${data.aws_vpc.drone.id}"
  target_type = "instance"
  stickiness  = []

  # see https://github.com/terraform-providers/terraform-provider-aws/issues/636
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "drone_server" {
  target_group_arn = "${aws_lb_target_group.drone_server.arn}"
  target_id        = "${aws_instance.drone_server.id}"
  port             = 8000
}
