resource "aws_launch_configuration" "drone_agents" {
  depends_on = ["aws_cloudwatch_log_group.drone_agents"]

  name_prefix                 = "drone-agents"
  image_id                    = "${data.aws_ami.amazon.id}"
  instance_type               = "${var.drone_agent_instance_type}"
  security_groups             = ["${aws_security_group.drone_agent.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.drone_ec2_profile.name}"
  associate_public_ip_address = "false"

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.drone.name} >> /etc/ecs/ecs.config
EOF

  ebs_block_device {
    device_name = "/dev/xvdcz"
    volume_type = "gp2"
    volume_size = "22"
  }

  lifecycle {
    create_before_destroy = true
  }
}
