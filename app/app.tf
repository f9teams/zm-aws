data "aws_route53_zone" "blockchain_domain" {
  name = "lonni.me"
}

resource "aws_acm_certificate" "blockchain_app" {
  domain_name       = "*.lonni.me"
  validation_method = "DNS"

  tags {
    Name      = "${terraform.workspace}_certificate_blockchain_app"
    Workspace = "${terraform.workspace}"
    Project   = "blockchain"
  }
}

resource "aws_route53_record" "certificate_validation" {
  zone_id = "${data.aws_route53_zone.blockchain_domain.zone_id}"
  count   = "${length(aws_acm_certificate.blockchain_app.domain_validation_options)}"
  name    = "${lookup(aws_acm_certificate.blockchain_app.domain_validation_options[count.index], "resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.blockchain_app.domain_validation_options[count.index], "resource_record_type")}"
  records = ["${lookup(aws_acm_certificate.blockchain_app.domain_validation_options[count.index], "resource_record_value")}"]
  ttl     = 3600
}

resource "aws_route53_record" "blockchain_app" {
  zone_id = "${data.aws_route53_zone.blockchain_domain.zone_id}"
  name    = "bc.lonni.me"
  type    = "A"

  alias {
    zone_id                = "${aws_elb.blockchain_app.zone_id}"
    name                   = "${aws_elb.blockchain_app.dns_name}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "blockchain_mail" {
  zone_id = "${data.aws_route53_zone.blockchain_domain.zone_id}"
  name    = "bc-mail.lonni.me"
  type    = "A"
  records = ["${aws_eip.blockchain_manager1.public_ip}"]
  ttl     = 3600
}

resource "aws_route53_record" "blockchain_ptr" {
  zone_id = "${data.aws_route53_zone.blockchain_domain.zone_id}"
  name    = "bc.lonni.me"
  type    = "PTR"
  records = ["${aws_route53_record.blockchain_mail.name}"]
  ttl     = 3600
}

resource "aws_route53_record" "blockchain_mx" {
  zone_id = "${data.aws_route53_zone.blockchain_domain.zone_id}"
  name    = "bc.lonni.me"
  type    = "MX"
  records = ["1 ${aws_route53_record.blockchain_mail.name}"]
  ttl     = 3600
}
