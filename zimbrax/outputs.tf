output "bastion_fqdn" {
  value = "${module.bastion.fqdn}"
}

output "dockerhost_fgdn" {
  value = "${module.swarm.dockerhost_fqdn}"
}

output "docker_repositories" {
  value = "${module.platform.docker_repositories}"
}
