# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    post_install.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: agaley <agaley@student.42lyon.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/12/05 20:14:57 by agaley            #+#    #+#              #
#    Updated: 2022/12/06 03:20:01 by agaley           ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

sed -i 's/^Port 22/Port 4242/' /target/etc/ssh/sshd_config
sed -i 's/^.*PermitRootLogin.*$/PermitRootLogin no/' /target/etc/ssh/sshd_config
in-target ufw allow 4242
in-target ufw allow http
in-target ufw allow https
in-target systemctl enable ufw

sed -i 's/^PASS_MAX_DAYS.*$/PASS_MAX_DAYS\'$'\t30/' /target/etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*$/PASS_MIN_DAYS\'$'\t2/' /target/etc/login.defs
sed -i 's/^PASS_WARN_AGE.*$/PASS_WARN_AGE\'$'\t7/' /target/etc/login.defs
sed -i 's/^.*pam_cracklib\.so.*$/password required'$'\tpam_cracklib.so minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 reject_username enforce_for_root\
password required'$'\tpam_cracklib.so difok=7/' /target/etc/pam.d/common-password

mkdir /target/var/log/sudo
echo 'Defaults	passwd_tries=3' >> /target/etc/sudoers.d/42
echo 'Defaults	badpass_message="Not this. You are on Qwerty (:"' >> /target/etc/sudoers.d/42
echo 'Defaults	logfile="/var/log/sudo/audit"' >> /target/etc/sudoers.d/42
echo 'Defaults	log_input, log_output' >> /target/etc/sudoers.d/42
echo 'Defaults	iolog_dir="/var/log/sudo"' >> /target/etc/sudoers.d/42
echo 'Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"' >> /target/etc/sudoers.d/42

USR=agaley
USR_PSD=Unkn0wn107
ROOT_PSD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c16)

echo "Root password : $ROOT_PSD" > /target/root/passwd

in-target chpasswd <<<"$USR:$USR_PSD"
in-target chpasswd <<<"root:$ROOT_PSD"
# #echo $USR_PSD | sudo passwd agaley
# #echo $ROOT_PSD | sudo passwd root

in-target apt-install php7.4 php7.4-fpm php7.4-mysql php7.4-cli php7.4-curl php7.4-xml php-json php-zip php-mbstring php-gd php-intl php-cgi
