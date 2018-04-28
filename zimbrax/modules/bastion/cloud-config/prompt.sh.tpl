#! /bin/bash

configure_profile() {
  tee -a $HOME/.bash_profile << EOF

# cloud-init prompt.sh
ENVIRONMENT=${environment}
NORMAL="\033[0m"
RED="\033[0;31m"
[ \$$ENVIRONMENT == "prod" ] && COLOR=\$$RED || COLOR=\$$NORMAL
export PS1="\$${COLOR}[bastion \W]\\$ \$${NORMAL}"
EOF
}
export -f configure_profile
su ec2-user -c configure_profile
