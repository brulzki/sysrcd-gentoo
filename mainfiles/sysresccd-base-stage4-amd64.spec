subarch: amd64
version_stamp: baseos
target: stage4
rel_type: default
profile: default/linux/amd64/13.0
snapshot: 20130701
source_subpath: default/stage3-amd64-baseos
portage_confdir: /worksrc/sysresccd-src/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src/portage-overlay

stage4/use: -fortran

stage4/packages:
	app-arch/lbzip2
	app-editors/vim
	app-portage/eix
	app-portage/gentoolkit
	app-shells/zsh
	dev-libs/icu
	dev-libs/libxml2
	dev-perl/XML-LibXML
	dev-perl/XML-Parser
	dev-perl/XML-SAX-Base
	dev-perl/YAML-Syck
	dev-util/intltool
	dev-util/pkgconfig
	perl-core/File-Spec
	perl-core/Pod-Simple
	sys-apps/file
	sys-devel/bc
	sys-devel/autoconf
	sys-devel/autogen
	sys-devel/automake
	sys-devel/libtool
