resource "aws_security_group" "fs" {
  name   = "${local.env_prefix_u}fs"
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
    Name        = "${local.environment}_sg_fs"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
