# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gptfdisk/gptfdisk-0.8.5.ebuild,v 1.1 2012/05/31 07:06:06 ssuominen Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="gdisk - GPT partition table manipulator for Linux"
HOMEPAGE="http://www.rodsbooks.com/gdisk/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+icu"

RDEPEND="icu? ( dev-libs/icu )
	dev-libs/popt
	>=sys-libs/ncurses-5.7-r7"
DEPEND="${RDEPEND}"

src_compile() {
	use icu || sed -i -e 's!-licuio!!g' -e 's!-licuuc!!g' -e 's!-D USE_UTF16!!g' Makefile
	emake CXX="$(tc-getCXX)"
}

src_install() {
	local app
	for app in gdisk sgdisk cgdisk fixparts; do
		dosbin ${app}
		doman ${app}.8
	done
	dodoc NEWS README
}
