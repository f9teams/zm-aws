resource "aws_elasticache_replication_group" "cache" {
  replication_group_id          = "${local.env_prefix_d}cache"
  replication_group_description = "Managed by Terraform"
  engine                        = "redis"
  engine_version                = "3.2.10"
  parameter_group_name          = "default.redis3.2"
  port                          = "6379"
  node_type                     = "cache.m4.xlarge"

  availability_zones    = ["${local.availability_zones}"]
  number_cache_clusters = "${local.availability_zone_count}"
  subnet_group_name     = "${aws_elasticache_subnet_group.cache.name}"
  security_group_ids    = ["${aws_security_group.cache.id}"]
}

resource "aws_elasticache_subnet_group" "cache" {
  name       = "${local.env_prefix_d}subnet-group-blockchain"
  subnet_ids = ["${local.private_subnet_ids}"]
}

resource "aws_security_group" "cache" {
  name   = "${local.env_prefix_u}cache"
  vpc_id = "${aws_vpc.blockchain.id}"

  tags {
    Name        = "${local.environment}_sg_cache"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_route53_record" "cache" {
  zone_id = "${local.r53_zone_id}"
  name    = "${local.env_prefix_d}cache.lonni.me"
  type    = "CNAME"
  records = ["${aws_elasticache_replication_group.cache.primary_endpoint_address}"]
  ttl     = 60
}
