#!/bin/bash

USR=agaley
USR_PSD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c16)
ROOT_PSD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c16)

echo "$USR password : $USR_PSD"
echo "Root password : $ROOT_PSD"

chpasswd <<<"$USR:$USR_PSD"
chpasswd <<<"root:$ROOT_PSD"
#echo $USR_PSD | sudo passwd agaley
#echo $ROOT_PSD | sudo passwd root


