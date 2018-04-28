#! /bin/bash

cat << EOF > /etc/update-motd.d/30-banner
#! /bin/sh
export TERM=xterm-256color

ENVIRONMENT=${environment}
PROJECT=${project}
NORMAL="\033[0m"
RED="\033[0;31m"
[ \$$ENVIRONMENT == "prod" ] && COLOR=\$$RED || COLOR=\$$NORMAL

echo -e "\$${COLOR}"
echo -e "███████╗██╗███╗   ███╗██████╗ ██████╗  █████╗"
echo -e "╚══███╔╝██║████╗ ████║██╔══██╗██╔══██╗██╔══██╗"
echo -e "  ███╔╝ ██║██╔████╔██║██████╔╝██████╔╝███████║"
echo -e " ███╔╝  ██║██║╚██╔╝██║██╔══██╗██╔══██╗██╔══██║"
echo -e "███████╗██║██║ ╚═╝ ██║██████╔╝██║  ██║██║  ██║"
echo -e "╚══════╝╚═╝╚═╝     ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝"
echo -e "\$${NORMAL}"
echo -e "Role:\t\tBASTION"
echo -e "Project:\t\$${PROJECT^^}"
echo -e "Environment:\t\$${ENVIRONMENT^^}"
echo
EOF

chmod 0755 /etc/update-motd.d/30-banner

update-motd
