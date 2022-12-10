# Born2BeRoot

#### Born2BeRoot unattended install of Debian vm
> Works on Debian, probably on other debian-based distros.

This allows you to preseed an iso of Debian with predefined configurations.
It consists of create script which downloads Debian netinst iso,
insert preseed.cfg and scripts, repack iso, launch an install VM until poweroff
and launch the freshly installed system.

#### Requirements : `./install_requirements.sh`

#### Default
Bonus VM with Phpmyadmin as extra service

#### Part 1
Mandatory VM can be built using .simple post_install and preseed.
You need to rename the files (especially the name preseed.cfg should be kept).

## 1.  Edit preseed.cfg
- Change hostname to yourlogin42
- Change username to yourlogin
- Change passwords, all defaults to Unkn0wn107

## 2.  Create and launch VM
- `./create.sh`
- Launch vncviewer in another terminal, i use tigervnc-viewer
- Select Install and press enter
- Wait for full install to proceed
- The install vm should stop if no error occured
- Launch again vmcviewer, default crypt pass is Unkn0wn107
- Stop vncviewer

## 3.  Install bonus services
- ssh in the vm `ssh -p 4242 yourlogin@localhost`
- Run `./services_install.sh`

## 4.  Enjoy !


## >> Contributing <<
Feedbacks and contributions are welcome
AMA as an issue or reach me @unkn0wn107 - agaley (:

Suggested improvements :
- Select "Install" remotely to start the install process automatically
  - I read here and there things about telnet
- Feed the services_install.sh to ssh
- Make the script compatible with Mac : Machines will be soon on Linux, so ...

## >> Development <<
#### Reaching stable configs was quite hard (long) for me, due to :
- Quite poor documentation (especially partman expert recipe for lvm and crypt)
- The testing loop is long (ie. 1/2h to test late_command scripts)

#### An advice is to have a 3 terminal setup :
- Your ide with create, post_install and preseed
- Viewer / ssh : vncviewer in install mode, ssh in sysadmin mode
- VM : qemu with create

#### When you change the config and an error occurs in install mode :
- Try first to understand what happened if you know how to fix in your IDE
- Otherwise press ESC and select down to Execute a shell
- Check the install log /var/log/syslog : cat, tail, nano
- Fix preseed if you know or run other commands to debug
  - If you are late enough in the install process, /target is your system root
  - /cdrom contains the files create included in the iso
  - You must run `in-target ` before a command you want to run in target system
  - If you are stuck with an in-target already launched, use `chroot /target`
- Thrash your VM when you are done with ctrl+c on create terminal
- Recreate `./create.sh`


