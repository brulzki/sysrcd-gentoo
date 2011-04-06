# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/gtkterm/gtkterm-0.99.5-r1.ebuild,v 1.3 2011/03/23 07:36:43 ssuominen Exp $

EAPI=2

DESCRIPTION="A serial port terminal written in GTK+, similar to Windows' HyperTerminal."
HOMEPAGE="http://www.jls-info.com/julien/linux/"
SRC_URI="http://fedorahosted.org/released/gtkterm/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="nls"

RDEPEND="x11-libs/gtk+:2
	x11-libs/vte:0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	echo "DEBUG: S=[${S}] and pwd=[$(pwd)]"
	ls -lh ${S}
	sed -i -e 's!src po!src!' ${S}/Makefile.in
	#( cd ${S} ; echo "PWD=" ; pwd ; sed -i -e 's!src po!src!' Makefile.am ; autoreconf )
	#sed -i -e 's!src po!src!' ${S}/Makefile.am
}

src_install() {
	einstall || die "einstall failed"
}
