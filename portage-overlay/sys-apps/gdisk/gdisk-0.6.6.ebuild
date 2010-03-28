# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gdisk/gdisk-0.6.4_p2.ebuild,v 1.1 2010/02/27 23:25:29 alexxy Exp $

EAPI="2"

inherit eutils

DESCRIPTION="gdisk - GPT partition table manipulator for Linux"
HOMEPAGE="http://www.rodsbooks.com/gdisk/"
SRC_URI="mirror://sourceforge/gptfdisk/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""

S="${WORKDIR}/${P/_p2/}"

src_install()
{
	for x in gdisk sgdisk; do
		dosbin "${x}" || die
		doman "${x}.8" || die
	done
}
