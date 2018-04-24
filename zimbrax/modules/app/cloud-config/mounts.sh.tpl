#! /bin/bash
mkdir -p /mnt/blockchain
echo "${blockchain_fs_id}:/ /mnt/blockchain efs tls,_netdev 0 0" >> /etc/fstab
mount -a -t efs defaults
chown ec2-user /mnt/blockchain