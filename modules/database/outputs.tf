output "drone_db_endpoint" {
  value = "${aws_db_instance.drone.address}"
}
