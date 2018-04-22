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
  subnet_id       = "${aws_subnet.blockchain_public.id}"
  security_groups = ["${aws_security_group.blockchain_fs.id}"]
}

resource "aws_security_group" "blockchain_fs" {
  name   = "${local.env_prefix_u}blockchain_fs"
  vpc_id = "${aws_vpc.blockchain.id}"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags {
    Name        = "${local.environment}_sg_blockchain_fs"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
