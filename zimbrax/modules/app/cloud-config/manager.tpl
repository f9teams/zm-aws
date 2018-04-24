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

write_files:
  - path: /etc/docker/daemon.json
    content: |
      {
        "hosts": [
          "tcp://0.0.0.0:2375",
          "unix:///var/run/docker.sock"
        ]
      }

runcmd:
  - mkdir -p /mnt/blockchain
  - echo "${blockchain_fs_id}:/ /mnt/blockchain efs tls,_netdev 0 0" >> /etc/fstab
  - mount -a -t efs defaults
  - chown ec2-user /mnt/blockchain

  - usermod -aG docker ec2-user

  - systemctl enable docker.service
  - systemctl start docker.service
  - docker swarm init

final_message: |
  Blockchain Docker Swarm manager is initialized.