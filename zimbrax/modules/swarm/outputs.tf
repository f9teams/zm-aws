output "dockerhost_private_ip" {
  value = "${aws_instance.manager1.private_ip}"
}

output "dockerhost_fqdn" {
  value = "${aws_route53_record.dockerhost.fqdn}"
}

output "security_group_id" {
  value = "${aws_security_group.swarm.id}"
}

output "app_instance_ids" {
  value = ["${aws_instance.manager1.id}"]
}
