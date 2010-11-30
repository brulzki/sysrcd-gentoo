# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nm-applet/nm-applet-0.7.2.ebuild,v 1.5 2010/09/15 19:44:40 ssuominen Exp $

EAPI=2
inherit gnome2 eutils versionator
#autotools

#PATCH_VERSION="1a"

MY_P="${P/nm-applet/network-manager-applet}"
MYPV_MINOR=$(get_version_component_range)
#PATCHNAME="${P}-gentoo-patches-${PATCH_VERSION}"

DESCRIPTION="Gnome applet for NetworkManager."
HOMEPAGE="http://projects.gnome.org/NetworkManager/"
SRC_URI="mirror://gnome/sources/network-manager-applet/0.7/${MY_P}.tar.bz2"
#	http://dev.gentoo.org/~dagger/files/${PATCHNAME}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE=""

RDEPEND=">=sys-apps/dbus-1.2
	>=sys-apps/hal-0.5.9
	>=dev-libs/libnl-1.1
	>=net-misc/networkmanager-${MYPV_MINOR}
	>=net-wireless/wireless-tools-28_pre9
	>=net-wireless/wpa_supplicant-0.5.7
	>=dev-libs/glib-2.16
	>=x11-libs/libnotify-0.4.3
	>=x11-libs/gtk+-2.10
	>=gnome-base/libglade-2
	>=gnome-base/gnome-keyring-2.20
	>=gnome-base/gconf-2.20
	>=gnome-extra/policykit-gnome-0.9.2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.35"

DOCS="AUTHORS ChangeLog NEWS README"
# USE_DESTDIR="1"

S=${WORKDIR}/${MY_P}

pkg_setup () {
	G2CONF="${G2CONF} \
		--disable-more-warnings \
		--localstatedir=/var \
		--with-dbus-sys=/etc/dbus-1/system.d"
}

#src_prepare() {
#
#	EPATCH_SOURCE="${WORKDIR}/${PATCHNAME}"
#	EPATCH_SUFFIX="patch"
#	epatch && eautoreconf
#}
