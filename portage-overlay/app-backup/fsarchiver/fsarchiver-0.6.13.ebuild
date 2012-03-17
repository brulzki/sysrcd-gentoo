# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/fsarchiver/fsarchiver-0.6.12.ebuild,v 1.1 2011/11/20 12:03:38 hwoarang Exp $

EAPI="4"

inherit autotools eutils

DESCRIPTION="Flexible filesystem archiver for backup and deployment tool"
HOMEPAGE="http://www.fsarchiver.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug lzma lzo static"

DEPEND="dev-libs/libgcrypt
	>=app-arch/bzip2-1.0.2
	>=sys-apps/util-linux-2.19
	>=sys-fs/e2fsprogs-1.41.4
	>=sys-libs/e2fsprogs-libs-1.41.4
	lzma? ( >=app-arch/xz-utils-4.999.9_beta )
	lzo? ( >=dev-libs/lzo-2.02 )
	static? ( app-arch/bzip2[static-libs] )
	static? ( sys-apps/util-linux[static-libs] )
	static? ( lzo? ( dev-libs/lzo[static-libs] ) )
	static? ( lzma? ( app-arch/xz-utils[static-libs] ) )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/^\([a-z]*_CFLAGS.*\)-ggdb/\1/' src/Makefile.am || die "seding
	failed"
	eautoreconf
}

src_configure() {
	econf $(use_enable lzma) \
	$(use_enable lzo) \
	$(use_enable static) \
	$(use_enable debug devel)
}

src_install() {
	emake DESTDIR="${D}" install
}
