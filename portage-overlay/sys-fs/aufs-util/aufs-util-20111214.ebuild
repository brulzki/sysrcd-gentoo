# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Userspace utilities for aufs."
HOMEPAGE="http://aufs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	echo ""
}

src_install() {
	dosbin aubrsync
	dosbin aubusy
	dosbin auchk
}
