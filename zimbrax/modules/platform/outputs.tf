output "blockchain_vpc_id" {
  value = "${aws_vpc.blockchain.id}"
}

output "blockchain_public_subnet_id" {
  value = "${aws_subnet.blockchain_public.id}"
}

output "blockchain_fs_id" {
  value = "${aws_efs_mount_target.blockchain.file_system_id}"
}

output "blockchain_fs_sg_id" {
  value = "${aws_security_group.blockchain_fs.id}"
}
