output "public_ip" {
  value = "${aws_eip.bastion.public_ip}"
}

output "fqdn" {
  value = "${aws_route53_record.bastion.fqdn}"
}
