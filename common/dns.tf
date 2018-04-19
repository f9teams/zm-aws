data "aws_route53_zone" "blockchain_domain" {
  name = "lonni.me"
}

output "blockchain_domain_zone_id" {
  value = "${data.aws_route53_zone.blockchain_domain.zone_id}"
}

resource "aws_acm_certificate" "blockchain_app" {
  domain_name       = "*.lonni.me"
  validation_method = "DNS"

  tags {
    Name    = "certificate_blockchain_app"
    Project = "blockchain"
  }
}

output "blockchain_app_certificate_id" {
  value = "${aws_acm_certificate.blockchain_app.id}"
}

resource "aws_route53_record" "certificate_validation" {
  zone_id = "${data.aws_route53_zone.blockchain_domain.zone_id}"
  count   = "${length(aws_acm_certificate.blockchain_app.domain_validation_options)}"
  name    = "${lookup(aws_acm_certificate.blockchain_app.domain_validation_options[count.index], "resource_record_name")}"
  type    = "${lookup(aws_acm_certificate.blockchain_app.domain_validation_options[count.index], "resource_record_type")}"
  records = ["${lookup(aws_acm_certificate.blockchain_app.domain_validation_options[count.index], "resource_record_value")}"]
  ttl     = 3600
}
