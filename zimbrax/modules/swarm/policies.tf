resource "aws_security_group" "swarm" {
  name   = "${local.env_prefix_u}swarm"
  vpc_id = "${local.vpc_id}"

  tags {
    Name        = "${local.environment}_sg_swarm"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_security_group_rule" "swarm_ingress_docker_from_self" {
  type              = "ingress"
  from_port         = 2375
  to_port           = 2377
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.swarm.id}"
  description       = "2375 unsecure Docker socket. 2376 for tls secure Docker socket. Required for Docker Machine. 2377 for communication between the nodes of a Docker Swarm, only needed on manager nodes."
}

resource "aws_security_group_rule" "swarm_ingress_udp_docker_overlay_networking_from_self" {
  type              = "ingress"
  from_port         = 4789
  to_port           = 4789
  protocol          = "udp"
  self              = true
  security_group_id = "${aws_security_group.swarm.id}"
  description       = "UDP 4789 for overlay network traffic (container ingress networking)"
}

resource "aws_security_group_rule" "swarm_ingress_tcp_docker_network_discovery_from_self" {
  type              = "ingress"
  from_port         = 7946
  to_port           = 7946
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.swarm.id}"
  description       = "TCP 7946 for communication among nodes (container network discovery)"
}

resource "aws_security_group_rule" "swarm_ingress_udp_docker_network_discovery_from_self" {
  type              = "ingress"
  from_port         = 7946
  to_port           = 7946
  protocol          = "udp"
  self              = true
  security_group_id = "${aws_security_group.swarm.id}"
  description       = "UDP 7946 for communication among nodes (container network discovery)"
}

resource "aws_security_group_rule" "swarm_egress_to_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = "${aws_security_group.swarm.id}"
  description       = "ALL"
}
