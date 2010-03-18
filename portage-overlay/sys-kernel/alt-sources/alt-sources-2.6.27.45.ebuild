ETYPE="sources"
inherit kernel-2 eutils

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Linux kernel, including gentoo and sysresccd patches."
SRC_URI="mirror://kernel/linux/kernel/v2.6/linux-2.6.27.tar.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://kernel.sysresccd.org/"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-* amd64 x86"
IUSE=""

src_unpack()
{
	unpack linux-2.6.27.tar.bz2
	ln -s linux-${KV} linux
	mv linux-2.6.27 linux-${KV}
	cd linux-${KV}
	epatch ${FILESDIR}/alt-sources-2.6.27_01-stable.patch.bz2 || die "stable patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.27_02-sqlzma34.patch.bz2 || die "sqlzma-3.4 patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.27_03-aufs1.patch.bz2 || die "aufs patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.27_04-reiser4.patch.bz2 || die "reiser4 patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.27_05-loopaes.patch.bz2 || die "loopaes patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.27_06-ext4.patch.bz2 || die "ext4 patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.27_07-atl2.patch.bz2 || die "alt2 patch failed."
	oldextra=$(cat Makefile | grep "^EXTRAVERSION")
	sed -i -e "s/${oldextra}/EXTRAVERSION = .45-alt150/" Makefile
}

