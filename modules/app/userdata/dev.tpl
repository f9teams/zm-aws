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
  usermod -a -G docker ec2-user
}
configure_docker

configure_user()
{
  tee -a $HOME/.bash_profile << EOF

export GOPATH=\$HOME/go
export PATH=\$GOPATH/bin:$PATH
export DOCKER_HOST=${blockchain_manager1_private_ip}
EOF

  source $HOME/.bash_profile
  go get -v -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

  mkdir -p $HOME/.docker
  tee $HOME/.docker/config.json << EOF
{
	"credsStore": "ecr-login"
}
EOF
}
export -f configure_user
su ec2-user -c configure_user