resource "aws_ecs_cluster" "drone" {
  name = "drone"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ecs_service" "drone_server" {
  depends_on = [
    "aws_lb_target_group_attachment.drone_server",
  ]

  name            = "drone-server"
  iam_role        = "${aws_iam_role.drone_ecs_service_role.arn}"
  cluster         = "${aws_ecs_cluster.drone.id}"
  task_definition = "${aws_ecs_task_definition.drone_server.arn}"
  desired_count   = 1

  launch_type = "EC2"

  load_balancer {
    target_group_arn = "${aws_lb_target_group.drone_server.arn}"
    container_name   = "drone-server"
    container_port   = "8000"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.instance-type == ${var.drone_server_instance_type}"
  }
}

resource "aws_ecs_service" "drone_agents" {
  name            = "drone-agents"
  cluster         = "${aws_ecs_cluster.drone.id}"
  task_definition = "${aws_ecs_task_definition.drone_agent.arn}"
  desired_count   = "${var.drone_agent_count}"

  // Will stop half the agents and deploy the other half
  //
  // This is required since we can only have one agent for host, so we need to
  // stop some of them before the update!
  deployment_maximum_percent = 100

  deployment_minimum_healthy_percent = 50

  placement_constraints {
    type = "distinctInstance"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.instance-type == ${var.drone_agent_instance_type}"
  }

  depends_on = [
    "aws_ecs_task_definition.drone_server",
  ]
}

resource "aws_ecs_task_definition" "drone_server" {
  family                   = "drone-server"
  execution_role_arn       = "${aws_iam_role.drone_ecs_task_execution_role.arn}"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]

  container_definitions = "${data.template_file.drone_server.rendered}"
}

resource "aws_ecs_task_definition" "drone_agent" {
  family                   = "drone-agent"
  execution_role_arn       = "${aws_iam_role.drone_ecs_task_execution_role.arn}"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  container_definitions    = "${data.template_file.drone_agent.rendered}"

  volume {
    name      = "dockerd"
    host_path = "/var/run/docker.sock"
  }
}

data "template_file" "drone_server" {
  template = "${file("${path.module}/data/server.json")}"

  vars {
    aws_region          = "${var.aws_region}"
    drone_host          = "http://${aws_route53_record.drone.name}"
    drone_orgs          = "${var.drone_orgs}"
    drone_admin         = "${var.drone_admin}"
    drone_open          = "${var.drone_open}"
    drone_secret        = "${random_string.secret.result}"
    drone_github_client = "${var.drone_github_client}"
    drone_github_secret = "${var.drone_github_secret}"
    drone_db_username   = "drone"
    drone_db_password   = "${var.drone_db_password}"
    drone_db_endpoint   = "${var.drone_db_endpoint}"
    awslogs_group       = "${aws_cloudwatch_log_group.drone_server.name}"
  }
}

data "template_file" "drone_agent" {
  template = "${file("${path.module}/data/agent.json")}"

  vars {
    aws_region    = "${var.aws_region}"
    drone_secret  = "${random_string.secret.result}"
    drone_server  = "${aws_route53_record.grpc.name}"
    awslogs_group = "${aws_cloudwatch_log_group.drone_agents.name}"
  }
}
