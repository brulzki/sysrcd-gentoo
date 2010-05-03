ETYPE="sources"
inherit kernel-2 eutils

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Linux kernel, including gentoo and sysresccd patches."
SRC_URI="mirror://kernel/linux/kernel/v2.6/linux-2.6.33.tar.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://kernel.sysresccd.org/"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-* amd64 x86"
IUSE=""

src_unpack()
{
	unpack linux-2.6.33.tar.bz2
	ln -s linux-${KV} linux
	mv linux-2.6.33 linux-${KV}
	cd linux-${KV}
	epatch ${FILESDIR}/alt-sources-2.6.33_01-stable.patch.bz2 || die "stable patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.33_02-sqlzma40.patch.bz2 || die "sqlzma patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.33_03-aufs2.patch.bz2 || die "aufs2 patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.33_04-reiser4.patch.bz2 || die "reiser4 patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.33_05-loopaes.patch.bz2 || die "loopaes patch failed."
	oldextra=$(cat Makefile | grep "^EXTRAVERSION")
	sed -i -e "s/${oldextra}/EXTRAVERSION = .03-alt153/" Makefile
}

