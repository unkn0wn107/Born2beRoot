# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    status.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: agaley <agaley@student.42lyon.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/12/06 22:27:29 by agaley            #+#    #+#              #
#    Updated: 2022/12/11 22:25:13 by agaley           ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

#!/bin/sh

wall <<EOF
#Architecture: $(uname -a)
#CPU physical: $(lscpu | grep '^CPU(s)' | awk '{ print $2 }')
#vCPU: $(awk '/cpu cores/{s+=$4} END {print s}' /proc/cpuinfo)
#Memory Usage: $(free -m | grep Mem | awk '{printf "%s/%sMB (%.2f%%)", $3,$2,$3*100/$2 }')
#Disk Usage: $(df -h | grep ' /$' | awk '{printf "%d/%s (%s)", $3,$2,$5}')
#CPU Load: $(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}')
#Last boot: $(who -b | awk '{print $3" "$4" "$5}')
#LVM use: $(lsblk | grep lvm | wc -l | awk '{ print $0 ? "yes" : "no" }')
#Connection TCP: $(ss -t | grep ESTAB | wc -l) ESTABLISHED
#User log: $(who | awk '{print $1}' | sort -u | wc -l)
#Network: IP $(hostname -I | awk '{print $1}') ($(cat /sys/class/net/ens3/address))
#Sudo: $(grep 'COMMAND' /var/log/sudo/audit | wc -l) cmd
EOF
