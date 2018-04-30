data "aws_availability_zones" "available" {}

locals {
  availability_zones = "${data.aws_availability_zones.available.names}"
}

module "platform" {
  source = "./modules/platform"

  availability_zones = "${local.availability_zones}"

  r53_zone_id = "${local.r53_zone_id}"
  db_password = "${local.db_password}"

  containers = [
    "redis",
    "zmc-ldap",
    "zmc-mta",
    "zmc-mailbox",
    "zmc-account",
    "zm-x-web",
    "zmc-mysql",
    "zmc-proxy",
    "zmc-solr",
  ]
}

module "swarm" {
  source = "./modules/swarm"

  availability_zones = "${local.availability_zones}"

  vpc_id             = "${module.platform.vpc_id}"
  private_subnet_ids = "${module.platform.private_subnet_ids}"

  deployer_key_pair_id = "${local.deployer_key_pair_id}"
  user_public_keys     = "${local.user_public_keys}"

  r53_zone_id = "${local.r53_zone_id}"

  file_system_id                = "${module.platform.file_system_id}"
  file_system_security_group_id = "${module.platform.file_system_security_group_id}"

  cache_security_group_id = "${module.platform.cache_security_group_id}"

  db_security_group_id = "${module.platform.db_security_group_id}"
}

module "bastion" {
  source = "./modules/bastion"

  vpc_id           = "${module.platform.vpc_id}"
  public_subnet_id = "${module.platform.public_subnet_ids[0]}"

  r53_zone_id = "${local.r53_zone_id}"

  user_public_keys     = "${local.user_public_keys}"
  deployer_key_pair_id = "${local.deployer_key_pair_id}"

  file_system_id                = "${module.platform.file_system_id}"
  file_system_security_group_id = "${module.platform.file_system_security_group_id}"

  cache_security_group_id = "${module.platform.cache_security_group_id}"

  db_security_group_id = "${module.platform.db_security_group_id}"
  db_fqdn              = "${module.platform.db_fqdn}"

  swarm_security_group_id = "${module.swarm.security_group_id}"
}

# module "app" {
#   source = "./modules/app"


#   vpc_id                  = "${module.platform.vpc_id}"
#   r53_zone_id             = "${local.r53_zone_id}"
#   app_certificate_id      = "${local.app_certificate_id}"
#   public_subnet_ids       = "${module.platform.public_subnet_ids}"
#   app_instance_ids        = "${module.swarm.app_instance_ids}"
#   swarm_security_group_id = "${module.swarm.security_group_id}"
# }

