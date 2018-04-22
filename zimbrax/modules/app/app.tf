resource "aws_route53_record" "blockchain_app" {
  zone_id = "${local.blockchain_domain_zone_id}"
  name    = "${local.env_prefix_d}bc.lonni.me"
  type    = "A"

  alias {
    zone_id                = "${aws_elb.blockchain_app.zone_id}"
    name                   = "${aws_elb.blockchain_app.dns_name}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "blockchain_mail" {
  zone_id = "${local.blockchain_domain_zone_id}"
  name    = "${local.env_prefix_d}bc-mail.lonni.me"
  type    = "A"
  records = ["${aws_instance.blockchain_manager1.public_ip}"]
  ttl     = 3600
}

resource "aws_route53_record" "blockchain_ptr" {
  zone_id = "${local.blockchain_domain_zone_id}"
  name    = "${local.env_prefix_d}bc.lonni.me"
  type    = "PTR"
  records = ["${aws_route53_record.blockchain_mail.name}"]
  ttl     = 3600
}

resource "aws_route53_record" "blockchain_mx" {
  zone_id = "${local.blockchain_domain_zone_id}"
  name    = "${local.env_prefix_d}bc.lonni.me"
  type    = "MX"
  records = ["1 ${aws_route53_record.blockchain_mail.name}"]
  ttl     = 3600
}
