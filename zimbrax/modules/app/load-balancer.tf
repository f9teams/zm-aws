resource "aws_elb" "app" {
  name    = "${local.env_prefix_d}app"
  subnets = ["${local.public_subnet_ids}"]

  listener {
    ssl_certificate_id = "${local.app_certificate_id}"
    lb_port            = 443
    lb_protocol        = "https"
    instance_port      = 443
    instance_protocol  = "https"
  }

  listener {
    ssl_certificate_id = "${local.app_certificate_id}"
    lb_port            = 8443
    lb_protocol        = "https"
    instance_port      = 8081
    instance_protocol  = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 8
    timeout             = 30
    target              = "HTTPS:443/"
    interval            = 60
  }

  instances                 = ["${local.app_instance_ids}"]
  cross_zone_load_balancing = true
  connection_draining       = true

  tags {
    Name        = "${local.environment}_elb_app"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}
