#! /bin/bash
configure_profile() {
  tee -a $HOME/.bash_profile << EOF

# cloud-init mysql-client.sh
export MYSQL_HOST=${db_fqdn}
EOF
}
export -f configure_profile
su ec2-user -c configure_profile
