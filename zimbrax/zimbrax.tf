module "platform" {
  source = "./modules/platform"

  r53_zone_id = "${local.r53_zone_id}"

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

# module "swarm" {
#   source = "./modules/swarm"


#   user_public_keys     = "${local.user_public_keys}"
#   deployer_key_pair_id = "${local.deployer_key_pair_id}"
#   r53_zone_id          = "${local.r53_zone_id}"
#   vpc_id               = "${module.platform.vpc_id}"
#   public_subnet_ids    = "${module.platform.public_subnet_ids}"


#   file_system {
#     id                = "${module.platform.file_system_id}"
#     security_group_id = "${module.platform.file_system_security_group_id}"
#   }
# }


# module "bastion" {
#   source = "./modules/bastion"


#   user_public_keys     = "${local.user_public_keys}"
#   deployer_key_pair_id = "${local.deployer_key_pair_id}"
#   r53_zone_id          = "${local.r53_zone_id}"
#   vpc_id               = "${module.platform.vpc_id}"
#   public_subnet_id     = "${module.platform.public_subnet_ids[0]}"


#   file_system {
#     id                = "${module.platform.file_system_id}"
#     security_group_id = "${module.platform.file_system_security_group_id}"
#   }


#   swarm {
#     dockerhost_private_ip = "${module.swarm.dockerhost_private_ip}"
#     security_group_id     = "${module.swarm.security_group_id}"
#   }
# }


# module "app" {
#   source = "./modules/app"


#   vpc_id                  = "${module.platform.vpc_id}"
#   r53_zone_id             = "${local.r53_zone_id}"
#   app_certificate_id      = "${local.app_certificate_id}"
#   public_subnet_ids       = "${module.platform.public_subnet_ids}"
#   app_instance_ids        = "${module.swarm.app_instance_ids}"
#   swarm_security_group_id = "${module.swarm.security_group_id}"
# }

