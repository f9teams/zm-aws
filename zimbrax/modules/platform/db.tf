resource "aws_db_instance" "db" {
  identifier                 = "${local.env_prefix_d}db"
  multi_az                   = true
  db_subnet_group_name       = "${aws_db_subnet_group.db.id}"
  engine                     = "mariadb"
  engine_version             = "10.2.12"
  parameter_group_name       = "default.mariadb10.2"
  port                       = 3306
  instance_class             = "db.m4.xlarge"
  storage_type               = "io1"
  iops                       = "1000"
  allocated_storage          = "100"
  name                       = "zimbra"
  username                   = "root"
  password                   = "${local.db_password}"
  vpc_security_group_ids     = ["${aws_security_group.db.id}"]
  backup_retention_period    = 31
  final_snapshot_identifier  = "${local.env_prefix_d}db-final-snapshot"
  auto_minor_version_upgrade = true

  tags {
    Name        = "${local.environment}_db_blockchain"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "${local.env_prefix_d}subnet-group-blockchain"
  subnet_ids = ["${local.private_subnet_ids}"]
}

resource "aws_security_group" "db" {
  name   = "${local.env_prefix_u}db"
  vpc_id = "${aws_vpc.blockchain.id}"

  tags {
    Name        = "${local.environment}_sg_db"
    Environment = "${local.environment}"
    Project     = "blockchain"
  }
}

resource "aws_route53_record" "db" {
  zone_id = "${local.r53_zone_id}"
  name    = "${local.env_prefix_d}db.lonni.me"
  type    = "CNAME"
  records = ["${aws_db_instance.db.address}"]
  ttl     = 60
}
