output "vpc_id" {
  value = "${aws_vpc.blockchain.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.id}"]
}

output "file_system_id" {
  value = "${aws_efs_mount_target.blockchain.file_system_id}"
}

output "file_system_security_group_id" {
  value = "${aws_security_group.fs.id}"
}

output "docker_repositories" {
  value = "${zipmap(local.containers, aws_ecr_repository.blockchain.*.repository_url)}"
}
