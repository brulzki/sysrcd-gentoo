subarch: amd64
version_stamp: mini
target: livecd-stage1
rel_type: default
profile: default/linux/amd64/17.0
snapshot: 20181110
source_subpath: default/stage4-amd64-baseos
portage_confdir: /worksrc/sysresccd-src/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src/portage-overlay

livecd/use: -* threads ssl unicode zlib

livecd/packages:
	app-arch/lbzip2
	app-arch/unzip
	app-arch/xz-utils
	app-editors/vim
	app-shells/bash
	app-shells/zsh
	dev-libs/libdnet
	dev-libs/libelf
	dev-libs/libgcrypt
	dev-python/setuptools
	dev-util/gperf
	dev-util/meson
	dev-util/pkgconfig
	dev-util/re2c
	dev-vcs/git
	net-libs/libtirpc
	sys-apps/attr
	sys-apps/ethtool
	sys-devel/autogen
	sys-devel/bc
	sys-devel/crossdev
	sys-devel/gettext
	sys-fs/fuse
	sys-fs/lsscsi
	sys-libs/zlib
	x11-libs/libpciaccess
	x11-libs/libdrm

