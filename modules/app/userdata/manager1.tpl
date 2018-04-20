#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

ensure_dependencies()
{
  yum update -y
  yum install -y git docker make golang
}
ensure_dependencies

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
}
configure_docker