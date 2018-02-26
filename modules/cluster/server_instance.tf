resource "aws_instance" "drone_server" {
  depends_on = ["aws_cloudwatch_log_group.drone_server"]

  ami                         = "${data.aws_ami.amazon.id}"
  instance_type               = "${var.drone_server_instance_type}"
  subnet_id                   = "${element(data.aws_subnet_ids.private.ids, 0)}"
  vpc_security_group_ids      = ["${aws_security_group.drone_server.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.drone_ec2_profile.name}"
  monitoring                  = true
  associate_public_ip_address = true

  ebs_block_device {
    device_name = "/dev/xvdcz"
    volume_type = "gp2"
    volume_size = "22"
  }

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.drone.name} >> /etc/ecs/ecs.config
EOF

  tags {
    Name        = "drone-server"
    Provisioner = "Terraform"
  }

  volume_tags {
    Name        = "drone-server"
    Provisioner = "Terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}
