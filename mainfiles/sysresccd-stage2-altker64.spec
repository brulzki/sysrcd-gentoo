subarch: amd64
version_stamp: 1.6-alt
target: livecd-stage2
rel_type: default
profile: default/linux/x86/10.0
snapshot: 20101009
source_subpath: default/livecd-stage1-amd64-1.6
portage_confdir: /worksrc/sysresccd-src-1.6/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src-1.6/portage-overlay

livecd/fstype: none
livecd/cdtar: /usr/lib/catalyst/livecd/cdtar/isolinux-3.09-cdtar.tar.bz2
livecd/iso: /worksrc/isofiles/systemrescuecd-amd64-current.iso
livecd/splash_type: 
livecd/splash_theme: 
livecd/bootargs: dokeymap
livecd/gk_mainargs: --makeopts="-j5" --integrated-initramfs
livecd/type: generic-livecd
livecd/readme:
livecd/motd: 
livecd/modblacklist:
livecd/overlay: /worksrc/sysresccd-src-1.6/overlay-iso-x86
livecd/devmanager: udev
livecd/users:

boot/kernel: altker64

boot/kernel/altker64/sources: sys-kernel/alt-sources
boot/kernel/altker64/config: /worksrc/sysresccd-src-1.6/kernelcfg/config-amd64-2.6.32-alt162.conf
boot/kernel/altker64/use: pcmcia usb -X png truetype 
boot/kernel/altker64/extraversion: amd64
boot/kernel/altker64/packages:
	app-accessibility/speakup
	net-dialup/hsfmodem
	net-dialup/globespan-adsl
	net-misc/openswan
	net-wireless/ndiswrapper

