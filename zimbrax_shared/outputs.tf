output "blockchain_domain_zone_id" {
  value = "${data.aws_route53_zone.blockchain_domain.zone_id}"
}

output "blockchain_app_certificate_id" {
  value = "${aws_acm_certificate.blockchain_app.id}"
}

output "blockchain_deployer_key_pair_id" {
  value = "${aws_key_pair.blockchain_deployer.id}"
}

output "blockchain_user_public_keys" {
  value = "${aws_key_pair.blockchain_user.*.public_key}"
}
