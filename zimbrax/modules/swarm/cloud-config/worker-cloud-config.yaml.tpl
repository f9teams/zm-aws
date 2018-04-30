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
    name: Docker CE
  centos-extras:
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
  - amazon-efs-utils
  - haveged
  - docker-ce

write_files:
  - path: /etc/sysconfig/selinux
    content: |
      SELINUX=enforcing
      SELINUXTYPE=targeted
  - path: /etc/profile.d/tfenv.sh
    permissions: "0755"
    content: |
      # environment variables managed by Terraform
      export TF_ENV=${environment}
      export TF_PROJECT=${project}
      export TF_ROLE=${role}
      export TERM_NORMAL="\033[0m"
      export TERM_RED="\033[0;31m"
      [ $$TF_ENV == "prod" ] && export TERM_COLOR=$$TERM_RED || export TERM_COLOR=$$TERM_NORMAL
      export PS1="\[$${TERM_COLOR}\][$${TF_ROLE} \W]$$ \[$${TERM_NORMAL}\]"
  - path: /etc/docker/daemon.json
    content: |
      {
        "hosts": [
          "tcp://0.0.0.0:2375",
          "unix:///var/run/docker.sock"
        ]
      }

runcmd:
  - systemctl enable haveged.service
  - usermod -aG docker ec2-user

power_state:
  mode: reboot
  message: "rebooting cloud-init complete"