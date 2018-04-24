#cloud-config
output:
  all: '| tee -a /var/log/cloud-init-output.log'

${ssh_authorized_keys}

yum_repos:
  docker:
    baseurl: https://download.docker.com/linux/centos/7/x86_64/stable
    enabled: true
    failovermethod: priority
    gpgcheck: true
    gpgkey: https://download.docker.com/linux/centos/gpg
    name: Docker CE packages from Docker repo
  centos_extras:
    baseurl: http://mirror.centos.org/centos/7/extras/x86_64
    enabled: true
    failovermethod: priority
    gpgcheck: true
    gpgkey: http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7
    name: CentOS-7 - Extras
  epel:
    baseurl: https://dl.fedoraproject.org/pub/epel/7/x86_64/
    enabled: true
    failovermethod: priority
    gpgcheck: true
    gpgkey: https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
    name: Extra Packages for Enterprise Linux (or EPEL)

repo_update: true
repo_upgrade: all

packages:
  - git
  - amazon-efs-utils
  - haveged
  - docker-ce

write_files:
  - path: /etc/sysconfig/selinux
    content: |
      SELINUX=enforcing
      SELINUXTYPE=targeted
  - path: /etc/docker/daemon.json
    content: |
      {
        "hosts": [
          "tcp://0.0.0.0:2375",
          "unix:///var/run/docker.sock"
        ]
      }

runcmd:
  - usermod -aG docker ec2-user
  - docker swarm init

power_state:
  mode: reboot
  message: cloud-init complete, rebooting