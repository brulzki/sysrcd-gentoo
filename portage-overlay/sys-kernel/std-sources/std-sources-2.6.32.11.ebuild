ETYPE="sources"
inherit kernel-2 eutils

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Linux kernel, including gentoo and sysresccd patches."
SRC_URI="mirror://kernel/linux/kernel/v2.6/linux-2.6.32.tar.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://kernel.sysresccd.org"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-* amd64 x86"
IUSE=""

src_unpack()
{
	unpack linux-2.6.32.tar.bz2
	ln -s linux-${KV} linux
	mv linux-2.6.32 linux-${KV}
	cd linux-${KV}
	epatch ${FILESDIR}/std-sources-2.6.32_01-stable.patch.bz2 || die "std-sources stable patch failed."
	epatch ${FILESDIR}/std-sources-2.6.32_02-sqlzma40.patch.bz2 || die "std-sources sqlzma patch failed."
	epatch ${FILESDIR}/std-sources-2.6.32_03-aufs2.patch.bz2 || die "std-sources aufs patch failed."
	epatch ${FILESDIR}/std-sources-2.6.32_04-reiser4.patch.bz2 || die "std-sources reiser4 patch failed."
	epatch ${FILESDIR}/std-sources-2.6.32_05-loopaes.patch.bz2 || die "std-sources loopaes patch failed."
	oldextra=$(cat Makefile | grep "^EXTRAVERSION")
	sed -i -e "s/${oldextra}/EXTRAVERSION = .11-std152/" Makefile
}

