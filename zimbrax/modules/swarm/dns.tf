resource "aws_eip" "manager1" {
  instance = "${aws_instance.manager1.id}"
  vpc      = true

  tags {
    Name        = "${local.environment}_ip_manager1"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_route53_record" "dockerhost" {
  zone_id = "${local.r53_zone_id}"
  name    = "${local.env_prefix_d}dockerhost.lonni.me"
  type    = "A"
  records = ["${aws_eip.manager1.private_ip}"]
  ttl     = 3600
}
