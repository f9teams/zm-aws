output "vpc_id" {
  value = "${aws_vpc.blockchain.id}"
}

output "public_subnet_ids" {
  value = ["${local.public_subnet_ids}"]
}

output "private_subnet_ids" {
  value = ["${local.private_subnet_ids}"]
}

output "file_system_id" {
  # use file_system_id from aws_efs_mount_target instead of id from aws_efs_file_system
  # because we don't want downstream instances to be manufatured until the mount target
  # exists, efs mount targets are slow to create
  value = "${aws_efs_file_system.network_file_system.id}"
}

output "file_system_security_group_id" {
  value = "${aws_security_group.network_file_system.id}"
}

output "cache_security_group_id" {
  value = "${aws_security_group.cache.id}"
}

output "db_security_group_id" {
  value = "${aws_security_group.db.id}"
}

output "docker_repositories" {
  value = "${zipmap(local.containers, aws_ecr_repository.blockchain.*.repository_url)}"
}

output "cache_fqdn" {
  value = "${aws_route53_record.cache.fqdn}"
}

output "db_fqdn" {
  value = "${aws_route53_record.db.fqdn}"
}
