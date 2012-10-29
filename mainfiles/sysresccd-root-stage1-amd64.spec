subarch: amd64
version_stamp: mini
target: livecd-stage1
rel_type: default
profile: default/linux/x86/10.0
snapshot: 20121019
source_subpath: default/stage4-amd64-20120505-01
portage_confdir: /worksrc/sysresccd-src/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src/portage-overlay

livecd/use: -* threads ssl unicode zlib

livecd/packages:
	app-arch/xz-utils
	app-editors/vim
	app-shells/bash
	dev-vcs/git
	sys-devel/autogen
	sys-devel/crossdev
	sys-devel/gettext
	dev-libs/libdnet
