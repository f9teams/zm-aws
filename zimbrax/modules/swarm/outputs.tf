output "dockerhost_private_ip" {
  value = "${aws_instance.manager1.private_ip}"
}

output "security_group_id" {
  value = "${aws_security_group.swarm.id}"
}

output "app_instance_ids" {
  value = ["${aws_instance.manager1.id}"]
}
