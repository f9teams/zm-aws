output "vpc_id" {
  value = "${aws_vpc.blockchain.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.id}"]
}

output "file_system_id" {
  # use file_system_id from aws_efs_mount_target instead of id from aws_efs_file_system
  # because we don't want downstream instances to be manufatured until the mount target
  # exists, efs mount targets are slow to create
  value = "${aws_efs_mount_target.blockchain.file_system_id}"
}

output "file_system_security_group_id" {
  value = "${aws_security_group.fs.id}"
}

output "docker_repositories" {
  value = "${zipmap(local.containers, aws_ecr_repository.blockchain.*.repository_url)}"
}
