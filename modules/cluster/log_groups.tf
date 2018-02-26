resource "aws_cloudwatch_log_group" "drone_server" {
  name_prefix       = "/ecs/drone/server"
  retention_in_days = 14

  tags {
    Provisioner   = "Terraform"
  }
}

resource "aws_cloudwatch_log_group" "drone_agents" {
  name_prefix       = "/ecs/drone/agent"
  retention_in_days = 14

  tags {
    Provisioner   = "Terraform"
  }
}
