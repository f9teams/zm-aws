resource "aws_security_group" "fs" {
  name   = "${local.env_prefix_u}fs"
  vpc_id = "${aws_vpc.blockchain.id}"

  tags {
    Name        = "${local.environment}_sg_fs"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_security_group_rule" "ingress_fs_nfs_from_self" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.fs.id}"
  description       = "NFS (EFS)"
}
