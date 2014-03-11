subarch: amd64
version_stamp: mini
target: livecd-stage1
rel_type: default
profile: default/linux/amd64/13.0
snapshot: 20140301
source_subpath: default/stage4-amd64-baseos
portage_confdir: /worksrc/sysresccd-src/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src/portage-overlay

livecd/use: -* threads ssl unicode zlib

livecd/packages:
	app-arch/lbzip2
	app-arch/xz-utils
	app-editors/vim
	app-shells/bash
	app-shells/zsh
	dev-libs/libdnet
	dev-vcs/git
	sys-devel/autogen
	sys-devel/crossdev
	sys-devel/gettext
	sys-apps/ethtool
	sys-devel/bc

