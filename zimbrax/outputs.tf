output "bastion_public_ip" {
  value = "${module.bastion.public_ip}"
}

output "bastion_fqdn" {
  value = "${module.bastion.fqdn}"
}

output "docker_repositories" {
  value = "${module.platform.docker_repositories}"
}

output "cache_fqdn" {
  value = "${module.platform.cache_fqdn}"
}

output "db_fqdn" {
  value = "${module.platform.db_fqdn}"
}
