# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/partimage/partimage-0.6.7.ebuild,v 1.6 2009/05/22 16:38:16 flameeyes Exp $

WANT_AUTOMAKE="1.10"

inherit eutils flag-o-matic pam autotools

DESCRIPTION="Console-based application to efficiently save raw partition data to an image file."
HOMEPAGE="http://www.partimage.org/"
SRC_URI="mirror://sourceforge/partimage/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0.6.9"
KEYWORDS="amd64 x86"
IUSE="ssl nologin nls pam static"

DEPEND="virtual/libc
	>=sys-libs/zlib-1.1.4
	>=dev-libs/newt-0.52.2
	app-arch/bzip2
	>=sys-libs/slang-1.4
	nls? ( sys-devel/gettext )
	ssl? ( >=dev-libs/openssl-0.9.6g )"

RDEPEND="!static? ( virtual/libc
		>=sys-libs/zlib-1.1.4
		>=dev-libs/lzo-1.08
		>=dev-libs/newt-0.52.2
		app-arch/bzip2
		>=sys-libs/slang-1.4
		nls? ( sys-devel/gettext )		ssl? ( >=dev-libs/openssl-0.9.6g )
		pam? ( virtual/pam )
	)"

PARTIMAG_GROUP_GID=91
PARTIMAG_USER_UID=91
PARTIMAG_GROUP_NAME=partimag
PARTIMAG_USER_NAME=partimag
PARTIMAG_USER_SH=-1
PARTIMAG_USER_HOMEDIR=/var/log/partimage
PARTIMAG_USER_GROUPS=partimag

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.6.7-datadir-path.patch || die
}

src_compile() {
	filter-flags -fno-exceptions
	use ppc && append-flags -fsigned-char

	local myconf
	use nologin && myconf="${myconf} --disable-login"
	if use static
	then
		use pam && ewarn "pam and static compilation are mutually exclusive - using static and ignoring pam"
	else
		myconf="${myconf} `use_enable pam`"
	fi
	econf \
		${myconf} \
		--sysconfdir=/etc \
		`use_enable ssl` \
		`use_enable nls` \
		`use_enable static all-static` \
		|| die "econf failed"

	emake || die "make failed"
}

src_install() {
	mv ${S}/src/client/partimage ${S}/src/client/partimage-${PV}
	mv ${S}/src/server/partimaged ${S}/src/server/partimaged-${PV}
	dosbin ${S}/src/client/partimage-${PV}
	dosbin ${S}/src/server/partimaged-${PV}
}

