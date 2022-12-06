# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    status.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: agaley <agaley@student.42lyon.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/12/06 22:27:29 by agaley            #+#    #+#              #
#    Updated: 2022/12/06 02:22:57 by agaley           ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

wall $'\n#Architecture: '"$(uname -a)" \
$'\n#CPU physical: '"$(lscpu | grep '^CPU(s)' | awk '{ print $2 }')" \
$'\n#vCPU: '"$(cat /proc/cpuinfo | grep processor | wc -l)" \
$'\n#Memory Usage: '"$(free -m | grep Mem | awk '{printf "%s/%sMB (%.2f%%)", $3,$2,$3*100/$2 }')" \
$'\n#Disk Usage: '"$(df -h | grep ' /$' | awk '{printf "%d/%s (%s)", $3,$2,$5}')" \
$'\n#CPU Load: '"$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')" \
$'\n#Last boot: '"$(who -b | awk '{print $3" "$4" "$5}')" \
$'\n#LVM use: '"$(lsblk |grep lvm | awk '{if ($1) {print "yes";exit;} else {print "no"} }')" \
$'\n#Connection TCP: '"$(netstat -an | grep ESTABLISHED |  wc -l)" \
$'\n#User log: '"$(who | cut -d " " -f 1 | sort -u | wc -l)" \
$'\n#Network: IP '"$(hostname -I)($(cat /sys/class/net/eth0/address))" \
$'\n#Sudo: '"$(grep 'sudo ' /var/log/auth.log | wc -l) cmd"
