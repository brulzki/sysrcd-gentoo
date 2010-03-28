subarch: amd64
version_stamp: 1.5-std
target: livecd-stage2
rel_type: default
profile: default/linux/x86/10.0
snapshot: 20100327
source_subpath: default/livecd-stage1-amd64-1.5
portage_confdir: /worksrc/sysresccd-src/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src/portage-overlay

livecd/fstype: none
livecd/cdtar: /usr/lib/catalyst/livecd/cdtar/isolinux-3.09-cdtar.tar.bz2
livecd/iso: /worksrc/isofiles/systemrescuecd-amd64-current.iso
livecd/splash_type: 
livecd/splash_theme: 
livecd/bootargs: dokeymap
livecd/gk_mainargs: --makeopts="-j5"
livecd/linuxrc: /worksrc/sysresccd-src/mainfiles/linuxrc
livecd/type: generic-livecd
livecd/readme:
livecd/motd: 
livecd/modblacklist:
livecd/overlay: /worksrc/sysresccd-src/overlay-iso-x86
livecd/root_overlay: /worksrc/sysresccd-src/overlay-squashfs-x86
livecd/devmanager: udev
livecd/users:
livecd/volid: sysresccd

boot/kernel: rescue64

boot/kernel/rescue64/sources: sys-kernel/std-sources
boot/kernel/rescue64/config: /worksrc/sysresccd-src/kernelcfg/config-amd64-2.6.32-std151.conf
boot/kernel/rescue64/use: pcmcia usb -X png truetype 
boot/kernel/rescue64/extraversion: amd64
boot/kernel/rescue64/initramfs_overlay: /worksrc/sysresccd-src/overlay-initramfs
boot/kernel/rescue64/packages:
	net-dialup/speedtouch-usb
	net-dialup/hsfmodem
	app-accessibility/speakup
	net-wireless/ndiswrapper
	sys-block/iscsitarget
	sys-cluster/drbd-kernel
	#net-wireless/broadcom-sta
	#sys-fs/cowloop
	#sys-block/open-iscsi

