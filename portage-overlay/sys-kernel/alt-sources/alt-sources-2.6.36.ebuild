ETYPE="sources"
inherit kernel-2 eutils

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Linux kernel, including gentoo and sysresccd patches."
SRC_URI="mirror://kernel/linux/kernel/v2.6/linux-2.6.36.tar.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://kernel.sysresccd.org"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-* amd64 x86"
IUSE=""

src_unpack()
{
	unpack linux-2.6.36.tar.bz2
	ln -s linux-${KV} linux
	mv linux-2.6.36 linux-${KV}
	cd linux-${KV}
	epatch ${FILESDIR}/alt-sources-2.6.36-01-fc15-012-stable03.patch.bz2 || die "alt-sources stable/fedora patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.36-02-squash-xz.patch.bz2 || die "alt-sources squash-xz patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.36-03-aufs21.patch.bz2 || die "alt-sources aufs21 patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.36-04-reiser4.patch.bz2 || die "alt-sources reiser4 patch failed."
	epatch ${FILESDIR}/alt-sources-2.6.36-05-speakup.patch.bz2 || die "alt-sources speakup patch failed."
	sedlockdep='s!.*#define MAX_LOCKDEP_SUBCLASSES.*8UL!#define MAX_LOCKDEP_SUBCLASSES 16UL!'
	sed -i -e ${sedlockdep} include/linux/lockdep.h
	sednoagp='s!int nouveau_noagp;!int nouveau_noagp=1;!g'
	sed -i -e ${sednoagp} drivers/gpu/drm/nouveau/nouveau_drv.c
	oldextra=$(cat Makefile | grep "^EXTRAVERSION")
	sed -i -e "s/${oldextra}/EXTRAVERSION = -alt201/" Makefile
}

