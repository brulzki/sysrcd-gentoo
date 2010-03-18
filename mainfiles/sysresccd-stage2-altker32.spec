subarch: i386
version_stamp: 1.5-alt
target: livecd-stage2
rel_type: default
profile: default/linux/x86/10.0
snapshot: 20100315
source_subpath: default/livecd-stage1-i386-1.5
portage_confdir: /worksrc/sysresccd-src/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src/portage-overlay

livecd/fstype: none
livecd/cdtar: /usr/lib/catalyst/livecd/cdtar/isolinux-3.09-cdtar.tar.bz2
livecd/iso: /worksrc/isofiles/systemrescuecd-x86-current.iso
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

boot/kernel: altker32

boot/kernel/altker32/sources: sys-kernel/alt-sources
boot/kernel/altker32/config: /worksrc/sysresccd-src/kernelcfg/config-x86-2.6.27-alt150.conf
boot/kernel/altker32/use: pcmcia usb -X png truetype 
boot/kernel/altker32/extraversion: i386
boot/kernel/altker32/initramfs_overlay: /worksrc/sysresccd-src/overlay-initramfs
boot/kernel/altker32/packages:
	app-accessibility/speakup
	net-dialup/speedtouch-usb
	net-dialup/hcfpcimodem
	net-dialup/hsfmodem
	net-dialup/globespan-adsl
	net-misc/openswan
	net-wireless/ndiswrapper

