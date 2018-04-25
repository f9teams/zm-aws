output "bastion_public_ip" {
  value = "${module.bastion.public_ip}"
}

output "bastion_fqdn" {
  value = "${module.bastion.fqdn}"
}

output "dockerhost_private_ip" {
  value = "${module.swarm.dockerhost_private_ip}"
}

output "docker_repositories" {
  value = "${module.platform.docker_repositories}"
}
