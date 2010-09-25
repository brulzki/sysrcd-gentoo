# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-vmmouse/xf86-input-vmmouse-12.6.9.ebuild,v 1.3 2010/07/13 13:24:58 fauli Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="VMWare mouse input driver"
IUSE=""
KEYWORDS="amd64 x86 ~x86-fbsd"

RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	>=x11-proto/inputproto-1.4.1
	x11-proto/randrproto
	x11-proto/xproto"

src_unpack()
{
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/vmmouse-12.6.9-single-udev-match.patch"
	epatch "${FILESDIR}/vmmouse-12.6.9-iopl-revert.patch"
}

