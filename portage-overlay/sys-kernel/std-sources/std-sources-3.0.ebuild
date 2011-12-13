EAPI="2"
ETYPE="sources"
inherit kernel-2 eutils

S=${WORKDIR}/linux-${KV}

DESCRIPTION="Full sources for the Linux kernel, including gentoo and sysresccd patches."
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-3.0.tar.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://kernel.sysresccd.org"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-* arm amd64 x86"
IUSE=""

src_unpack()
{
	unpack linux-3.0.tar.bz2
	ln -s linux-${KV} linux
	mv linux-3.0 linux-${KV}
	cd linux-${KV}
	epatch ${FILESDIR}/std-sources-3.0-01-stable-3.0.13.patch.bz2 || die "std-sources stable patch failed."
	epatch ${FILESDIR}/std-sources-3.0-02-fc15.patch.bz2 || die "std-sources fedora patch failed."
	epatch ${FILESDIR}/std-sources-3.0-03-aufs.patch.bz2 || die "std-sources aufs patch failed."
	epatch ${FILESDIR}/std-sources-3.0-04-loopaes.patch.bz2 || die "std-sources loopaes patch failed."
	epatch ${FILESDIR}/std-sources-3.0-05-yaffs2.patch.bz2 || die "std-sources yaffs2 patch failed."
	sedlockdep='s!.*#define MAX_LOCKDEP_SUBCLASSES.*8UL!#define MAX_LOCKDEP_SUBCLASSES 16UL!'
	sed -i -e "${sedlockdep}" include/linux/lockdep.h
	sednoagp='s!int nouveau_noagp;!int nouveau_noagp=1;!g'
	sed -i -e "${sednoagp}" drivers/gpu/drm/nouveau/nouveau_drv.c
	oldextra=$(cat Makefile | grep "^EXTRAVERSION")
	sed -i -e "s/${oldextra}/EXTRAVERSION = -std241/" Makefile
}

