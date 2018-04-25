resource "aws_eip" "bastion" {
  instance = "${aws_instance.bastion.id}"
  vpc      = true

  tags {
    Name        = "${local.environment}_ip_bastion"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_route53_record" "bastion" {
  zone_id = "${local.r53_zone_id}"
  name    = "${local.env_prefix_d}bastion.lonni.me"
  type    = "A"
  records = ["${aws_eip.bastion.public_ip}"]
  ttl     = 3600
}
