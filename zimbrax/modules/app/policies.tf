resource "aws_security_group_rule" "app_ingress_accountapi_from_all" {
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = "${local.swarm_security_group_id}"
  description       = "HTTPS, Account Provisioning API"
}

resource "aws_security_group_rule" "app_ingress_https_from_all" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = "${local.swarm_security_group_id}"
  description       = "HTTPS, ZimbraX UI"
}
