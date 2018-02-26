output "drone_server_private_dns" {
  value = "${aws_instance.drone_server.private_dns}"
}

output "drone_server_lb_dns" {
  value = "${aws_lb.drone_server.dns_name}"
}

output "drone_server_cname" {
  value = "${aws_route53_record.drone.name}"
}

output "drone_grpc_cname" {
  value = "${aws_route53_record.grpc.name}"
}

output "drone_server_sg" {
  value = "${aws_security_group.drone_server.id}"
}


output "drone_cluster_name" {
  value = "${aws_ecs_cluster.drone.name}"
}
