# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/squashfs-tools/squashfs-tools-4.1.ebuild,v 1.3 2010/11/14 13:49:59 jlec Exp $

EAPI="2"

inherit toolchain-funcs eutils

#MY_PV=${PV}
MY_PV="4.1"
DESCRIPTION="Tool for creating compressed filesystem type squashfs"
HOMEPAGE="http://squashfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/squashfs/squashfs${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="+gzip +lzma lzo xattr"

RDEPEND="gzip? ( sys-libs/zlib )
	lzma? ( app-arch/xz-utils )
	lzo? ( dev-libs/lzo )
	!lzma? ( !lzo? ( sys-libs/zlib ) )
	xattr? ( sys-apps/attr )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/squashfs${MY_PV}/squashfs-tools

src_prepare() {
	epatch "${FILESDIR}/squashfs-tools-4.1-xz.patch" || die "cannot add support for xz"
	sed -i -e 's!#XZ_SUPPORT = 1!XZ_SUPPORT = 1!g' Makefile
	sed -i -e 's!COMP_DEFAULT = gzip!COMP_DEFAULT = xz!g' Makefile
	sed -i \
		-e "s:-O2:${CFLAGS} ${CPPFLAGS}:" \
		-e '/^LIBS =/s:$: $(LDFLAGS):' \
		Makefile || die
}

src_install() {
	dobin mksquashfs unsquashfs || die
	cd ..
	dodoc README ACKNOWLEDGEMENTS CHANGES PERFORMANCE.README || die
}

pkg_postinst() {
	ewarn "This version of mksquashfs requires a 2.6.29 kernel or better"
}
