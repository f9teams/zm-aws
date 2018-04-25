resource "aws_security_group" "swarm" {
  name   = "${local.env_prefix_u}swarm"
  vpc_id = "${local.vpc_id}"

  ingress {
    from_port   = 2375
    to_port     = 2377
    protocol    = "tcp"
    self        = true
    description = "2375 unsecure Docker socket. 2376 for tls secure Docker socket. Required for Docker Machine. 2377 for communication between the nodes of a Docker Swarm, only needed on manager nodes."
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    self        = true
    description = "TCP 7946 for communication among nodes (container network discovery)"
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    self        = true
    description = "UDP 7946 for communication among nodes (container network discovery)"
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    self        = true
    description = "UDP 4789 for overlay network traffic (container ingress networking)"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags {
    Name        = "${local.environment}_sg_swarm"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
