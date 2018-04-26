resource "aws_efs_file_system" "network_file_system" {
  creation_token   = "${local.env_prefix_d}fs-blockchain"
  performance_mode = "maxIO"

  tags {
    Name        = "${local.environment}_file_system_blockchain"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_efs_mount_target" "blockchain" {
  count = "${local.availability_zone_count}"

  subnet_id       = "${element(values(module.private_subnets.availability_zone_to_private_subnet_id), count.index)}"
  file_system_id  = "${aws_efs_file_system.network_file_system.id}"
  security_groups = ["${aws_security_group.network_file_system.id}"]
}

resource "aws_security_group" "network_file_system" {
  name   = "${local.env_prefix_u}fs"
  vpc_id = "${aws_vpc.blockchain.id}"

  tags {
    Name        = "${local.environment}_sg_network_file_system"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_security_group_rule" "ingress_network_file_system_nfs_from_self" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.network_file_system.id}"
  description       = "NFS (EFS)"
}
