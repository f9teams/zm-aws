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

runcmd:
  - usermod -aG docker ec2-user