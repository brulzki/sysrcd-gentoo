subarch: amd64
version_stamp: 1.5-alt
target: livecd-stage2
rel_type: default
profile: default/linux/x86/10.0
snapshot: 20100707
source_subpath: default/livecd-stage1-amd64-1.5
portage_confdir: /worksrc/sysresccd-src-1.5/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src-1.5/portage-overlay

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
livecd/overlay: /worksrc/sysresccd-src-1.5/overlay-iso-x86
livecd/devmanager: udev
livecd/users:

boot/kernel: altker64

boot/kernel/altker64/sources: sys-kernel/alt-sources
boot/kernel/altker64/config: /worksrc/sysresccd-src-1.5/kernelcfg/config-amd64-2.6.34-alt158.conf
boot/kernel/altker64/use: pcmcia usb -X png truetype 
boot/kernel/altker64/extraversion: amd64
boot/kernel/altker64/packages:
	net-dialup/hsfmodem
	net-dialup/globespan-adsl
	net-misc/openswan
	net-wireless/ndiswrapper
	#app-accessibility/speakup

