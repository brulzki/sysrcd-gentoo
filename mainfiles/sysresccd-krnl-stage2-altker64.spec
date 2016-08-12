subarch: amd64
version_stamp: krnl
target: livecd-stage2
rel_type: default
profile: default/linux/x86/13.0
snapshot: 20160810
source_subpath: default/livecd-stage1-amd64-mini
portage_confdir: /worksrc/sysresccd-src/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src/portage-overlay

livecd/fstype: none
livecd/cdtar: /usr/lib/catalyst/livecd/cdtar/isolinux-3.72-cdtar.tar.bz2
livecd/iso: /worksrc/isofiles/systemrescuecd-amd64-current.iso
livecd/splash_type: 
livecd/splash_theme: 
livecd/bootargs: dokeymap
livecd/gk_mainargs: --makeopts="-j5" --integrated-initramfs
livecd/type: generic-livecd
livecd/readme:
livecd/motd: 
livecd/modblacklist:
livecd/overlay: /worksrc/sysresccd-src/overlay-iso-x86
livecd/users:

boot/kernel: altker64

boot/kernel/altker64/sources: sys-kernel/alt-sources
boot/kernel/altker64/config: /worksrc/sysresccd-src/kernelcfg/config-alt-x86_64.cfg
boot/kernel/altker64/use: pcmcia usb -X png truetype 
boot/kernel/altker64/extraversion: amd64
boot/kernel/altker64/packages:
	#app-emulation/open-vm-tools-kmod
	#sys-block/open-iscsi
