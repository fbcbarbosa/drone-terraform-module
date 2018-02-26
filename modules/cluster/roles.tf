data "aws_iam_policy_document" "drone_ecs_service_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "drone_ecs_task_execution_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "drone_ecs_service_role" {
  name_prefix        = "DroneECSServiceRole"
  assume_role_policy = "${data.aws_iam_policy_document.drone_ecs_service_policy.json}"
}

resource "aws_iam_role" "drone_ecs_task_execution_role" {
  name_prefix        = "DroneECSTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.drone_ecs_task_execution_policy.json}"
}

resource "aws_iam_role_policy_attachment" "drone_ecs_service_role_attachment" {
  role       = "${aws_iam_role.drone_ecs_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role_policy_attachment" "drone_ecs_task_execution_role_attachment" {
  role       = "${aws_iam_role.drone_ecs_task_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "drone_ec2_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "drone_ec2_role" {
  name_prefix        = "DroneECSInstanceRole"
  assume_role_policy = "${data.aws_iam_policy_document.drone_ec2_policy_document.json}"
}

// Give Drone Agent EC2 instances access to ECS
resource "aws_iam_role_policy_attachment" "drone_ec2_ecs_role_attachment" {
  role       = "${aws_iam_role.drone_ec2_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "drone_ec2_profile" {
  name_prefix = "drone-ecs-instance-profile"
  role        = "${aws_iam_role.drone_ec2_role.name}"
}
