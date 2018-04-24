data "aws_route53_zone" "blockchain_domain" {
  name = "lonni.me"
}

resource "aws_acm_certificate" "blockchain_app" {
  domain_name       = "*.lonni.me"
  validation_method = "DNS"

  tags {
    Name    = "certificate_blockchain_app"
    Project = "blockchain"
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
