output "blockchain_domain_zone_id" {
  value = "${data.aws_route53_zone.blockchain_domain.zone_id}"
}

output "blockchain_app_certificate_id" {
  value = "${aws_acm_certificate.blockchain_app.id}"
}

output "blockchain_deployer_key_pair_id" {
  value = "${aws_key_pair.blockchain_deployer.id}"
}

output "eric_key_pair_id" {
  value = "${aws_key_pair.eric.id}"
}

output "eric_key_pair_public_key" {
  value = "${aws_key_pair.eric.public_key}"
}
