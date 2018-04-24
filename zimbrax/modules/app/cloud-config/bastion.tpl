#cloud-config
output:
  all: '| tee -a /var/log/cloud-init-output.log'

ssh_authorized_keys:
  - "${eric_key_pair_public_key}"

yum_repos:
  docker:
    baseurl: https://yum.dockerproject.org/repo/main/centos/7
    enabled: true
    failovermethod: priority
    gpgcheck: true
    gpgkey: https://yum.dockerproject.org/gpg
    name: Docker CE packages from Docker repo

repo_update: true
repo_upgrade: all

packages:
  - git
  - amazon-efs-utils
  - docker-engine
  - python-pip
  - golang
  - make

write_files:
  - path: /tmp/init_ec2-user.sh
    owner: "root:root"
    permissions: "0555"
    content: |
      tee -a $HOME/.bash_profile << EOF

      export GOPATH=\$HOME/go
      export PATH=\$GOPATH/bin:$PATH
      export DOCKER_HOST=${blockchain_swarm_manager_ip}
      EOF

      source $HOME/.bash_profile
      go get -v -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

      mkdir -p $HOME/.docker
      tee $HOME/.docker/config.json << EOF
      {
        "credsStore": "ecr-login"
      }
      EOF

runcmd:
  - pip install --upgrade --force-reinstall pip==9.0.3 # pip install --upgrade pip
  - pip install docker-compose

  - mkdir -p /mnt/blockchain
  - echo "${blockchain_fs_id}:/ /mnt/blockchain efs tls,_netdev 0 0" >> /etc/fstab
  - mount -a -t efs defaults
  - chown ec2-user /mnt/blockchain

  - usermod -aG docker ec2-user

  - su ec2-user -c /tmp/init_ec2-user.sh

final_message: |
  Blockchain bastion is initialized.