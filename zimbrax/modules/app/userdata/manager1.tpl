#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

ensure_dependencies()
{
  yum update -y
  yum install -y docker amazon-efs-utils
}
ensure_dependencies

configure_efs() {
  mkdir -p /mnt/blockchain
  echo "${blockchain_fs_id}:/ /mnt/blockchain efs tls,_netdev" >> /etc/fstab
  mount -a -t efs defaults
}
configure_efs

configure_docker()
{
  mkdir -p /etc/docker
  tee /etc/docker/daemon.json << EOF
{
  "hosts": [
    "tcp://0.0.0.0:2375",
    "unix:///var/run/docker.sock"
  ]
}
EOF

  service docker restart
  usermod -a -G docker ec2-user

  docker swarm init
  # after cloud init is done "test -f /var/lib/cloud/instance/boot-finished"
  # until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  #  sleep 1
  # done
  # "docker swarm join $${blockchain_manager1_private_ip}:2377 --token $(docker -H $${blockchain_manager1_private_ip} swarm join-token -q worker)"
}
configure_docker