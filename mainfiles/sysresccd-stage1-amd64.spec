subarch: amd64
version_stamp: 1.5
target: livecd-stage1
rel_type: default
profile: default/linux/x86/10.0
snapshot: 20100611
source_subpath: default/stage4-amd64-20100522-01
portage_confdir: /worksrc/sysresccd-src/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src/portage-overlay

livecd/use: -* X bindist fbcon ipv6 livecd ncurses pam readline ssl unicode zlib nptl nptlonly multilib jfs ntfs reiserfs xfs fat reiser4 gtk2 png jpeg -svg -opengl xorg usb pdf acl nologin -dri -glx minimal atm -berkdb -gdbm slang -fortran -nls

livecd/packages:
	app-admin/syslog-ng
	app-arch/sharutils
	app-arch/unzip
	app-misc/livecd-tools
	app-misc/screen
	app-misc/symlinks
	app-portage/gentoolkit
	app-shells/bash
	dev-libs/lzo
	dev-util/pkgconfig
	net-misc/iputils
	net-dialup/ppp
	net-misc/wget
	net-wireless/wireless-tools
	sys-apps/coreutils
	sys-apps/diffutils
	sys-apps/hdparm
	sys-apps/hwsetup
	sys-apps/iproute2
	sys-apps/miscfiles
	sys-apps/pciutils
	sys-apps/sed
	sys-apps/shadow
	sys-apps/slocate
	sys-apps/util-linux
	sys-apps/which
	sys-fs/lvm2
	sys-fs/sysfsutils
	sys-fs/udev
	sys-kernel/linux-headers
	sys-kernel/gentoo-sources
