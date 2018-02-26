resource "aws_db_instance" "drone" {
  allocated_storage = "${var.drone_db_allocated_storage}"
  instance_class    = "${var.drone_db_instance_type}"

  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.19"
  identifier_prefix    = "drone"
  parameter_group_name = "default.mysql5.7"

  name     = "drone"
  username = "drone"
  password = "${var.drone_db_password}"

  db_subnet_group_name   = "${aws_db_subnet_group.drone.name}"
  vpc_security_group_ids = ["${aws_security_group.mysql_db.id}"]

  maintenance_window      = "Sun:00:00-Sun:03:00"
  backup_retention_period = 14
  backup_window           = "04:00-05:00"

  multi_az = false

  // Do this to avoid multiple snapshots with the same name
  final_snapshot_identifier = "${format("drone-%s", sha1(timestamp()))}"

  storage_encrypted     = "${var.drone_storage_encrypted}"
  apply_immediately     = true
  copy_tags_to_snapshot = true

  skip_final_snapshot = false
  publicly_accessible = false

  tags {
    Provisioner = "Terraform"
  }

  lifecycle {
    ignore_changes = [
      "final_snapshot_identifier"
    ]
  }
}

output "db-endpoint" {
  value = "${aws_db_instance.drone.endpoint}"
}
