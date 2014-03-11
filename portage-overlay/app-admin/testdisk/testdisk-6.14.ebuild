# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/testdisk/testdisk-6.12.ebuild,v 1.3 2011/07/21 18:12:26 c1pher Exp $

EAPI=2
inherit eutils flag-o-matic

DESCRIPTION="Checks and undeletes partitions + PhotoRec, signature based recovery tool"
HOMEPAGE="http://www.cgsecurity.org/wiki/TestDisk"
SRC_URI="http://www.cgsecurity.org/${P}.tar.bz2"
#SRC_URI="http://www.cgsecurity.org/${P}-WIP.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static reiserfs ntfs jpeg"
# WARNING: reiserfs support does NOT work with reiserfsprogs
# you MUST use progsreiserfs-0.3.1_rc8 (the last version ever released).
DEPEND=">=sys-libs/ncurses-5.2
		jpeg? ( virtual/jpeg )
	  	ntfs? ( sys-fs/ntfs3g )
	  	reiserfs? ( >=sys-fs/progsreiserfs-0.3.1_rc8 )
	  	>=sys-fs/e2fsprogs-1.35
		sys-libs/zlib"
RDEPEND="!static? ( ${DEPEND} )"

#S=${WORKDIR}/${P}-WIP

# merged upstream
#src_prepare() {
#	epatch "${FILESDIR}"/${P}-exif_bound_checking-v2.patch
#}

src_configure() {
	local myconf="--without-ewf --enable-sudo"
	# --with-foo are broken, any use of --with/--without disable the
	# functionality.
	# The following variation must be used.
	use reiserfs && myconf="${myconf} --with-reiserfs-lib=/usr/lib"
	use ntfs || myconf="${myconf} --without-ntfs"
	use jpeg || myconf="${myconf} --without-jpeg"

	# this is static method is the same used by upstream for their 'static' make
	# target, but better, as it doesn't break.
	use static && append-ldflags -static

	econf ${myconf} || die

	# perform safety checks for NTFS and REISERFS
	if use ntfs && ! egrep -q '^#define HAVE_LIBNTFS(3G)? 1$' "${S}"/config.h ; then
		die "Failed to find either NTFS or NTFS-3G library."
	fi
	if use reiserfs && egrep -q 'undef HAVE_LIBREISERFS\>' "${S}"/config.h ; then
		die "Failed to find reiserfs library."
	fi
	if use jpeg && egrep -q 'undef HAVE_LIBJPEG\>' "${S}"/config.h ; then
		die "Failed to find jpeg library."
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
	[ "$PF" != "$P" ] && mv "${D}"/usr/share/doc/${P} "${D}"/usr/share/doc/${PF}
}
