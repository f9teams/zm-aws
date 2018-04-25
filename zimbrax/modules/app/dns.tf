resource "aws_route53_record" "app" {
  zone_id = "${local.r53_zone_id}"
  name    = "${local.env_prefix_d}bc.lonni.me"
  type    = "A"

  alias {
    zone_id                = "${aws_elb.app.zone_id}"
    name                   = "${aws_elb.app.dns_name}"
    evaluate_target_health = false
  }
}

# resource "aws_route53_record" "mail" {
#   zone_id = "${local.r53_zone_id}"
#   name    = "${local.env_prefix_d}bc-mail.lonni.me"
#   type    = "A"
#   records = ["${aws_eip.manager1.public_ip}"]
#   ttl     = 3600
# }


# resource "aws_route53_record" "ptr" {
#   zone_id = "${local.r53_zone_id}"
#   name    = "${local.env_prefix_d}bc.lonni.me"
#   type    = "PTR"
#   records = ["${aws_route53_record.mail.name}"]
#   ttl     = 3600
# }


# resource "aws_route53_record" "mx" {
#   zone_id = "${local.r53_zone_id}"
#   name    = "${local.env_prefix_d}bc.lonni.me"
#   type    = "MX"
#   records = ["1 ${aws_route53_record.mail.name}"]
#   ttl     = 3600
# }

