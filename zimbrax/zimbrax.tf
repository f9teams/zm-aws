module "platform" {
  source = "./modules/platform"
}

module "app" {
  source                      = "./modules/app"
  blockchain_vpc_id           = "${module.platform.blockchain_vpc_id}"
  blockchain_public_subnet_id = "${module.platform.blockchain_public_subnet_id}"

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
