# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-vmmouse/xf86-input-vmmouse-12.8.0.ebuild,v 1.1 2012/03/09 00:05:33 chithanh Exp $

EAPI=4

inherit xorg-2

DESCRIPTION="VMWare mouse input driver"
IUSE=""
KEYWORDS="~amd64 ~x86 ~x86-fbsd"

RDEPEND=""
DEPEND="${RDEPEND}
	x11-proto/randrproto"

src_unpack()
{
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/vmmouse-12.6.9-iopl-revert.patch"
}

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		--with-hal-bin-dir=/punt
		--with-hal-callouts-dir=/punt
		--with-hal-fdi-dir=/punt
	)

	xorg-2_pkg_setup
}

src_install() {
	xorg-2_src_install
	rm -rf "${ED}"/punt
}
