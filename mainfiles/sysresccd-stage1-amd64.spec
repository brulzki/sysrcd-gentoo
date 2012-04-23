subarch: amd64
version_stamp: default
target: livecd-stage1
rel_type: default
profile: default/linux/x86/10.0
snapshot: 20120420
source_subpath: default/stage4-amd64-20111217-01
portage_confdir: /worksrc/sysresccd-src/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src/portage-overlay

livecd/use: -* X bindist fbcon ipv6 livecd ncurses pam readline ssl unicode zlib nptl nptlonly multilib jfs ntfs reiserfs xfs fat reiser4 gtk2 png jpeg -svg -opengl xorg usb pdf acl nologin -dri -glx minimal -atm -berkdb -gdbm slang -fortran -nls

livecd/packages:
	app-arch/sharutils
	app-arch/unzip
	app-misc/screen
	app-misc/symlinks
	app-portage/gentoolkit
	app-shells/bash
	net-misc/wget
	sys-apps/coreutils
	sys-apps/diffutils
	sys-apps/hdparm
	sys-apps/miscfiles
	sys-apps/sed
	sys-apps/shadow
	sys-apps/util-linux
	sys-apps/which
	sys-kernel/linux-headers
	sys-kernel/gentoo-sources
