# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lshw/lshw-02.15b.ebuild,v 1.14 2011/11/11 17:23:49 flameeyes Exp $

EAPI=3
inherit flag-o-matic eutils toolchain-funcs

MAJ_PV=${PV:0:${#PV}-1}
MIN_PVE=${PV:0-1}
MIN_PV=${MIN_PVE/b/B}

MY_P="$PN-$MIN_PV.$MAJ_PV"
DESCRIPTION="Hardware Lister"
HOMEPAGE="http://ezix.org/project/wiki/HardwareLiSter"
SRC_URI="http://ezix.org/software/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~x86-linux"
IUSE="gtk sqlite static"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}
	gtk? ( dev-util/pkgconfig )
	sqlite? ( dev-util/pkgconfig )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
}

src_compile() {
	tc-export CC CXX AR
	use static && append-ldflags -static

	local sqlite=0
	use sqlite && sqlite=1
	use sqlite || sed -i -e 's!-lsqlite3!!g' src/gui/Makefile

	emake SQLITE=$sqlite || die "emake failed"
	if use gtk ; then
		emake SQLITE=$sqlite gui || die "emake gui failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install || \
		die "install failed"
	dodoc README docs/*
	if use gtk ; then
		emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install-gui || \
			die "install gui failed"
		make_desktop_entry /usr/sbin/gtk-lshw "Hardware Lister" "/usr/share/lshw/artwork/logo.svg"
	fi
}

