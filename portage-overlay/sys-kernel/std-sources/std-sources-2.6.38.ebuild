ETYPE="sources"
inherit kernel-2 eutils

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Linux kernel, including gentoo and sysresccd patches."
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.38.tar.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://kernel.sysresccd.org"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-* amd64 x86"
IUSE=""

src_unpack()
{
	unpack linux-2.6.38.tar.bz2
	ln -s linux-${KV} linux
	mv linux-2.6.38 linux-${KV}
	cd linux-${KV}
	epatch ${FILESDIR}/std-sources-2.6.38-01-stable-2.6.38.8.patch.bz2 || die "std-sources stable patch failed."
	epatch ${FILESDIR}/std-sources-2.6.38-02-fc15-030.patch.bz2 || die "std-sources fedora patch failed."
	epatch ${FILESDIR}/std-sources-2.6.38-03-aufs.patch.bz2 || die "std-sources aufs patch failed."
	epatch ${FILESDIR}/std-sources-2.6.38-04-reiser4.patch.bz2 || die "std-sources reiser4 patch failed."
	epatch ${FILESDIR}/std-sources-2.6.38-05-loopaes.patch.bz2 || die "std-sources loopaes patch failed."
	sedlockdep='s!.*#define MAX_LOCKDEP_SUBCLASSES.*8UL!#define MAX_LOCKDEP_SUBCLASSES 16UL!'
	sed -i -e ${sedlockdep} include/linux/lockdep.h
	sednoagp='s!int nouveau_noagp;!int nouveau_noagp=1;!g'
	sed -i -e ${sednoagp} drivers/gpu/drm/nouveau/nouveau_drv.c
	oldextra=$(cat Makefile | grep "^EXTRAVERSION")
	sed -i -e "s/${oldextra}/EXTRAVERSION = -std220/" Makefile
}

