# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    create_vm.sh                                       :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: agaley <agaley@student.42lyon.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/11/21 21:00:58 by agaley            #+#    #+#              #
#    Updated: 2022/11/22 23:59:12 by alex             ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

ISO=debian-11.5.0-amd64-netinst.iso
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/$ISO

rm debian_11.qcow2

# Preseed iso files https://wiki.debian.org/DebianInstaller/Preseed/EditIso
7z x -oisofiles $ISO
chmod +w -R isofiles/install.amd/
gunzip isofiles/install.amd/initrd.gz
echo preseed.cfg | cpio -H newc -o -A -F isofiles/install.amd/initrd
gzip isofiles/install.amd/initrd
chmod -w -R isofiles/install.amd/
cd isofiles
chmod +w md5sum.txt
# Warning is OK - find: File system loop detected;
# ‘./debian’ is part of the same file system loop as ‘.’ :
find -follow -type f ! -name md5sum.txt -print0 | xargs -0 md5sum > md5sum.txt
chmod -w md5sum.txt
cd ..

# Repack preseeded iso https://wiki.debian.org/RepackBootableISO
# isofiles/.disk/mkisofs with stripped Jigdo
#dd if="$ISO" bs=1 count=432 of="$mbr_template"
xorriso -as mkisofs \
		-r -V 'Debian 11.5.0 amd64 n' \
		-o "preseeded-$ISO" -J -joliet-long -cache-inodes \
		-b isolinux/isolinux.bin -c isolinux/boot.cat \
		-boot-load-size 4 -boot-info-table -no-emul-boot \
		-eltorito-alt-boot -e boot/grub/efi.img \
		-no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
		isofiles

chmod +w -R isofiles
rm -r isofiles

# Launch unattended install
qemu-img create -f qcow2 debian_11.qcow2 8G
qemu-system-x86_64 -hda debian_11.qcow2 -cdrom preseeded-$ISO -boot d -m 2048


