#!/bin/bash
# Convenience script to launch VM

qemu-system-x86_64 -hda debian_11.qcow2 -boot d -m 2048	--enable-kvm \
		-nic user,hostfwd=tcp::4242-:4242 \
		-nic user,hostfwd=tcp::8080-:80
