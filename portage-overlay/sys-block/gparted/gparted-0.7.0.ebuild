# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils gnome2

DESCRIPTION="Gnome Partition Editor"
HOMEPAGE="http://gparted.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="fat gnome hfs jfs kde ntfs reiserfs reiser4 xfs xfce"

common_depends=">=sys-block/parted-2.2
		>=dev-cpp/gtkmm-2.8.0"

RDEPEND="${common_depends}
		kde? ( || ( kde-base/kdesu kde-base/kdebase ) )
		fat? ( sys-fs/dosfstools )
		ntfs? ( sys-fs/ntfsprogs )
		hfs? ( sys-fs/hfsutils )
		jfs? ( sys-fs/jfsutils )
		reiserfs? ( sys-fs/reiserfsprogs )
		reiser4? ( sys-fs/reiser4progs )
		xfs? ( sys-fs/xfsprogs sys-fs/xfsdump )"

DEPEND="${common_depends}
		>=sys-devel/gettext-0.17
		>=dev-util/pkgconfig-0.12
		>=dev-util/intltool-0.35.5"

src_compile() 
{
	cd "${S}"
	econf --disable-scrollkeeper --disable-doc
	emake all || die "make failed"
}

src_install() 
{
	gnome2_src_install
}

