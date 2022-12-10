# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    status.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: agaley <agaley@student.42lyon.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/12/06 22:27:29 by agaley            #+#    #+#              #
#    Updated: 2022/12/10 21:55:36 by agaley           ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

wall <<EOF
#Architecture: "$(uname -a)"
#CPU physical: "$(lscpu | grep '^CPU(s)' | awk '{ print $2 }')"
#vCPU: "$(cat /proc/cpuinfo | grep processor | wc -l)"
#Memory Usage: "$(free -m | grep Mem | awk '{printf "%s/%sMB (%.2f%%)", $3,$2,$3*100/$2 }')"
#Disk Usage: "$(df -h | grep ' /$' | awk '{printf "%d/%s (%s)", $3,$2,$5}')"
#CPU Load: "$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')"
#Last boot: "$(who -b | awk '{print $3" "$4" "$5}')"
#LVM use: "$(lsblk | grep lvm | awk '{if ($1) {print "yes";exit;} else {print "no"} }')"
#Connection TCP: "$(netstat -an | grep ESTABLISHED |  wc -l)"
#User log: "$(who | cut -d " " -f 1 | sort -u | wc -l)"
#Network: IP "$(hostname -I)($(cat /sys/class/net/eth0/address))"
#Sudo: "$(grep 'sudo ' /var/log/auth.log | wc -l) cmd"
EOF
