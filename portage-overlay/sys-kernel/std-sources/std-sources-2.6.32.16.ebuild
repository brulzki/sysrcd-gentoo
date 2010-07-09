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
	epatch ${FILESDIR}/std-sources-2.6.32_06-cciss-hpsa.patch.bz2 || die "std-sources cciss-hpsa patch failed."
	epatch ${FILESDIR}/std-sources-2.6.32_07-lsi-sw.patch.bz2 || die "std-sources lsi-sw patch failed."
	epatch ${FILESDIR}/std-sources-2.6.32_08-update-tg3.patch.bz2 || die "std-sources update-tg3 patch failed."
	epatch ${FILESDIR}/std-sources-2.6.32_09-phylib-autoload.patch.bz2 || die "std-sources phylib-autoload failed."
	epatch ${FILESDIR}/std-sources-2.6.32_10-update-bnx2.patch.bz2 || die "std-sources update-bnx2 failed."
	epatch ${FILESDIR}/std-sources-2.6.32_11-update-e1000e-ich9.patch.bz2 || die "std-sources update-e1000e failed."
	epatch ${FILESDIR}/std-sources-2.6.32_12-libata-trim.patch.bz2 || die "std-sources libata-trim failed."
	epatch ${FILESDIR}/std-sources-2.6.32_13-btrfs-fixes.patch.bz2 || die "std-sources btrfs-fixes failed."
	sedlockdep='s!.*#define MAX_LOCKDEP_SUBCLASSES.*8UL!#define MAX_LOCKDEP_SUBCLASSES 16UL!'
	sed -i -e ${sedlockdep} include/linux/lockdep.h
	oldextra=$(cat Makefile | grep "^EXTRAVERSION")
	sed -i -e "s/${oldextra}/EXTRAVERSION = .16-std158/" Makefile
}

