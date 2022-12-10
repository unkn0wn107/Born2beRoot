#!/bin/bash
# Convenience script to launch VM

qemu-system-x86_64 -hda debian_11.qcow2 -boot d -m 2048	--enable-kvm \
		-net nic -net user,hostfwd=tcp::4242-:4242
