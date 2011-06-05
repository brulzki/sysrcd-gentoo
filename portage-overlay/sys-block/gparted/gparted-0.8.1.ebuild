# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/gparted/gparted-0.8.0.ebuild,v 1.2 2011/05/11 08:56:47 eva Exp $

EAPI="2"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Gnome Partition Editor"
HOMEPAGE="http://gparted.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="btrfs dmraid fat gtk hfs jfs kde mdadm ntfs reiserfs reiser4 xfs"

# FIXME: add gpart support
common_depends=">=sys-block/parted-2.3
	>=dev-cpp/gtkmm-2.16:2.4"

RDEPEND="${common_depends}
	gtk? ( x11-libs/gksu )
	kde? ( || ( kde-base/kdesu kde-base/kdebase ) )

	>=sys-fs/e2fsprogs-1.41
	btrfs? ( sys-fs/btrfs-progs )
	dmraid? ( || (
			>=sys-fs/lvm2-2.02.45
			sys-fs/device-mapper )
		sys-fs/dmraid
		sys-fs/multipath-tools )
	fat? (
		sys-fs/dosfstools
		sys-fs/mtools )
	hfs? (
		sys-fs/diskdev_cmds
		sys-fs/udev
		sys-fs/hfsutils )
	jfs? ( sys-fs/jfsutils )
	mdadm? ( sys-fs/mdadm )
	ntfs? ( || (
		>=sys-fs/ntfs3g-2011.4.12[ntfsprogs]
		sys-fs/ntfsprogs ) )
	reiserfs? ( sys-fs/reiserfsprogs )
	reiser4? ( sys-fs/reiser4progs )
	xfs? ( sys-fs/xfsprogs sys-fs/xfsdump )"

DEPEND="${common_depends}
	>=dev-util/pkgconfig-0.12
	>=dev-util/intltool-0.35.5"

pkg_setup() {
	DOCS="AUTHORS NEWS ChangeLog README"
	G2CONF="${G2CONF} --disable-scrollkeeper --disable-doc GKSUPROG=$(type -P true)"
}

src_prepare() {
	gnome2_src_prepare

	# Revert upstream changes to use gksu inconditionally
	sed "s:Exec=@gksuprog@ :Exec=:" \
		-i gparted.desktop.in.in || die "sed 1 failed"
}

src_install() {
	gnome2_src_install

	if use kde; then
		cp "${D}"/usr/share/applications/gparted.desktop \
			"${D}"/usr/share/applications/gparted-kde.desktop

		sed -i "s:Exec=:Exec=kdesu :" "${D}"/usr/share/applications/gparted-kde.desktop
		echo "OnlyShowIn=KDE;" >> "${D}"/usr/share/applications/gparted-kde.desktop
	fi

	if use gtk; then
		sed -i "s:Exec=:Exec=gksu :" "${D}"/usr/share/applications/gparted.desktop
		echo "NotShowIn=KDE;" >> "${D}"/usr/share/applications/gparted.desktop
	else
		echo "OnlyShowIn=X-NeverShowThis;" >> "${D}"/usr/share/applications/gparted.desktop
	fi
}
