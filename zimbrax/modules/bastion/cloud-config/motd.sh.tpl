#! /bin/bash

cat << EOF > /etc/update-motd.d/30-banner
#! /bin/sh
export TERM=xterm-256color

# these environment variables do not seem to be present when update-motd is called
source /etc/profile.d/tfenv.sh

echo -e "\$${TERM_COLOR}"
echo -e "███████╗██╗███╗   ███╗██████╗ ██████╗  █████╗"
echo -e "╚══███╔╝██║████╗ ████║██╔══██╗██╔══██╗██╔══██╗"
echo -e "  ███╔╝ ██║██╔████╔██║██████╔╝██████╔╝███████║"
echo -e " ███╔╝  ██║██║╚██╔╝██║██╔══██╗██╔══██╗██╔══██║"
echo -e "███████╗██║██║ ╚═╝ ██║██████╔╝██║  ██║██║  ██║"
echo -e "╚══════╝╚═╝╚═╝     ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝"
echo -e "\$${TERM_NORMAL}"
echo -e "Role:\t\t\$${TF_ROLE^^}"
echo -e "Project:\t\$${TF_PROJECT^^}"
echo -e "Environment:\t\$${TF_ENV^^}"
echo
EOF

chmod 0755 /etc/update-motd.d/30-banner

update-motd
