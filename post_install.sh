# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    post_install.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: agaley <agaley@student.42lyon.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/12/05 20:14:57 by agaley            #+#    #+#              #
#    Updated: 2022/12/08 15:37:44 by alex             ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

sed -i 's/^Port 22/Port 4242/' /etc/ssh/sshd_config
sed -i 's/^.*PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config
ufw allow 4242
systemctl enable ufw

sed -i 's/^PASS_MAX_DAYS.*$/PASS_MAX_DAYS\'$'\t30/' /etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*$/PASS_MIN_DAYS\'$'\t2/' /etc/login.defs
sed -i 's/^PASS_WARN_AGE.*$/PASS_WARN_AGE\'$'\t7/' /etc/login.defs
sed -i 's/^.*pam_cracklib\.so.*$/password required'$'\tpam_cracklib.so minlen=10 ucredit=-1 dcredit=-1 maxrepeat=3 reject_username enforce_for_root\
password required'$'\tpam_cracklib.so difok=7/' /etc/pam.d/common-password

mkdir /var/log/sudo
echo 'Defaults	passwd_tries=3' >> /etc/sudoers.d/42
echo 'Defaults	badpass_message="Not this. You are on Qwerty (:"' >> /etc/sudoers.d/42
echo 'Defaults	logfile="/var/log/sudo/audit"' >> /etc/sudoers.d/42
echo 'Defaults	log_input, log_output' >> /etc/sudoers.d/42
echo 'Defaults	iolog_dir="/var/log/sudo"' >> /etc/sudoers.d/42
echo 'Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"' >> /etc/sudoers.d/42

USR=agaley
USR_PSD=Unkn0wn107
ROOT_PSD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c16)

echo "Root password : $ROOT_PSD" > /root/passwd

chpasswd <<<"$USR:$USR_PSD"
chpasswd <<<"root:$ROOT_PSD"
# #echo $USR_PSD | sudo passwd agaley
# #echo $ROOT_PSD | sudo passwd root

echo '*/10 * * * * root /bin/sh /root/status.sh' > /etc/cron.d/status
