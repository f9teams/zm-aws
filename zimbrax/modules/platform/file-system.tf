resource "aws_efs_file_system" "blockchain" {
  creation_token   = "${local.env_prefix_d}fs-blockchain"
  performance_mode = "maxIO"

  tags {
    Name        = "${local.environment}_file_system_blockchain"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_efs_mount_target" "blockchain" {
  file_system_id  = "${aws_efs_file_system.blockchain.id}"
  subnet_id       = "${aws_subnet.public.id}"
  security_groups = ["${aws_security_group.fs.id}"]
}
