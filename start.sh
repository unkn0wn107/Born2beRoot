#!/bin/bash
# Convenience script to launch VM

cat <<EOF

Launch vncviewer localhost in another terminal to enter crypt password
default password is : Unkn0wn107
If password is correct, you can immediately stop vncviewer and start :
ssh -p 4242 yourlogin@localhost
Or access Wordpress on http://localhost

On 1st start, run : ./services_install.sh

Note : sudo is used to be able forward port 80 on host.

EOF
sudo qemu-system-x86_64 -hda debian_11.qcow2 -boot d -m 2048	--enable-kvm \
		-nic user,hostfwd=tcp::4242-:4242,hostfwd=tcp::80-:80

