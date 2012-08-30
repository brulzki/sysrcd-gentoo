# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/epdfview/epdfview-0.1.8-r1.ebuild,v 1.4 2012/05/04 03:33:15 jdhore Exp $

EAPI=4
inherit eutils fdo-mime

DESCRIPTION="Lightweight PDF viewer using Poppler and GTK+ libraries."
HOMEPAGE="http://trac.emma-soft.com/epdfview/"
SRC_URI="http://trac.emma-soft.com/epdfview/chrome/site/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="cups nls test"

RDEPEND=">=app-text/poppler-0.12.3-r3[cairo]
	>=x11-libs/pango-1.28.4
	>=x11-libs/gtk+-2.6:2
	cups? ( >=net-print/cups-1.1 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( dev-util/cppunit )
	userland_GNU? ( >=sys-apps/findutils-4.4 )"

RESTRICT="test"

src_prepare() {
	sed -i \
		-e 's:Icon=icon_epdfview-48:Icon=epdfview:' \
		data/epdfview.desktop || die
	epatch "${FILESDIR}/${P}-swap-blue-red-channels.patch" \
		"${FILESDIR}/${P}-glib-2.31-build-fix.patch"
}

src_configure() {
	econf $(use_with cups) \
		$(use_enable nls)
}

src_install() {
	default

	local res
	for res in 24 32 48; do
		insinto /usr/share/icons/hicolor/${res}x${res}/apps
		newins data/icon_epdfview-${res}.png epdfview.png || die
	done
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
