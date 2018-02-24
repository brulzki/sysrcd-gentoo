subarch: i686
version_stamp: baseos
target: stage4
rel_type: default
profile: default/linux/x86/17.0
snapshot: 20180220
source_subpath: default/stage3-i686-baseos
portage_confdir: /worksrc/sysresccd-src/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src/portage-overlay

stage4/use: -fortran

stage4/packages:
	sys-apps/attr
	app-arch/lbzip2
	app-editors/vim
	app-portage/eix
	app-portage/gentoolkit
	app-shells/zsh
	dev-lang/python
	dev-libs/icu
	dev-libs/libxml2
	dev-perl/XML-LibXML
	dev-perl/XML-Parser
	dev-perl/XML-SAX-Base
	dev-perl/YAML-Syck
	dev-util/intltool
	dev-util/pkgconfig
	sys-apps/file
	sys-devel/bc
	sys-devel/autoconf
	sys-devel/autogen
	sys-devel/automake
	sys-devel/libtool
	sys-fs/eudev
