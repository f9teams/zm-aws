#! /bin/bash
pip install --upgrade --force-reinstall pip==9.0.3 # pip install --upgrade pip
pip install docker-compose

configure_profile() {
  tee -a $HOME/.bash_profile << EOF

# cloud-init docker-client.sh
export GOPATH=\$HOME/go
export PATH=\$GOPATH/bin:$PATH
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
export -f configure_profile
su ec2-user -c configure_profile
