resource "aws_autoscaling_group" "drone_agents" {
  name_prefix               = "drone-agents"
  max_size                  = "${2 * var.drone_agent_count}"
  min_size                  = "1"
  desired_capacity          = "${var.drone_agent_count}"
  vpc_zone_identifier       = ["${data.aws_subnet_ids.private.ids}"]
  launch_configuration      = "${aws_launch_configuration.drone_agents.name}"
  health_check_grace_period = "10"

  tags = [
    {
      key                 = "Name"
      value               = "drone-agent"
      propagate_at_launch = true
    },
    {
      key                 = "Provisioner"
      value               = "Terraform"
      propagate_at_launch = true
    },
  ]
}

output "autoscaling-group-agents" {
  value = "${aws_autoscaling_group.drone_agents.name}"
}
