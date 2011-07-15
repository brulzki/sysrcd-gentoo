ETYPE="sources"
inherit kernel-2 eutils

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Linux kernel, including gentoo and sysresccd patches."
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.39.tar.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://kernel.sysresccd.org"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-* amd64 x86"
IUSE=""

src_unpack()
{
	unpack linux-2.6.39.tar.bz2
	ln -s linux-${KV} linux
	mv linux-2.6.39 linux-${KV}
	cd linux-${KV}
	epatch ${FILESDIR}/alt-sources-2.6.39-01-stable-2.6.39.3.patch.bz2 || die "alt-sources stable patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.39-02-fc16.patch.bz2 || die "alt-sources fedora patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.39-03-aufs.patch.bz2 || die "alt-sources aufs patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.39-04-loopaes.patch.bz2 || die "alt-sources loopaes patch failed."
	#epatch ${FILESDIR}/alt-sources-2.6.39-03-reiser4.patch.bz2 || die "alt-sources reiser4 patch failed."
	sedlockdep='s!.*#define MAX_LOCKDEP_SUBCLASSES.*8UL!#define MAX_LOCKDEP_SUBCLASSES 16UL!'
	sed -i -e ${sedlockdep} include/linux/lockdep.h
	sednoagp='s!int nouveau_noagp;!int nouveau_noagp=1;!g'
	sed -i -e ${sednoagp} drivers/gpu/drm/nouveau/nouveau_drv.c
	oldextra=$(cat Makefile | grep "^EXTRAVERSION")
	sed -i -e "s/${oldextra}/EXTRAVERSION = -alt221/" Makefile
}

