# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/polkit/polkit-0.102.ebuild,v 1.8 2011/12/08 15:41:16 ssuominen Exp $

EAPI=4
inherit eutils pam

DESCRIPTION="Policy framework for controlling privileges for system-wide services"
HOMEPAGE="http://hal.freedesktop.org/docs/polkit/"
SRC_URI="http://hal.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="debug doc examples gtk +introspection kde nls pam"

RDEPEND=">=dev-libs/glib-2.28
	dev-libs/expat
	introspection? ( >=dev-libs/gobject-introspection-0.6.2 )
	pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	!!sys-auth/policykit
	dev-libs/libxslt
	dev-util/pkgconfig
	>=dev-util/intltool-0.36
	doc? ( >=dev-util/gtk-doc-1.13 )"
#app-text/docbook-xml-dtd:4.1.2
#app-text/docbook-xsl-stylesheets
PDEPEND=">=sys-auth/consolekit-0.4[policykit]
	pam? ( sys-auth/pambase[consolekit] )
	gtk? ( || ( >=gnome-extra/polkit-gnome-0.101 lxde-base/lxpolkit ) )
	kde? ( || ( sys-auth/polkit-kde-agent sys-auth/polkit-kde ) )"

DOCS=( docs/TODO HACKING NEWS README )

src_configure() {
	local myauth="--with-authfw=shadow"
	use pam && myauth="--with-authfw=pam --with-pam-module-dir=$(getpam_mod_dir)"

	econf \
		--localstatedir="${EPREFIX}"/var \
		--disable-static \
		$(use_enable debug verbose-mode) \
		--disable-man-pages \
		--disable-gtk-doc \
		$(use_enable introspection) \
		--disable-examples \
		$(use_enable nls) \
		--with-os-type=gentoo \
		${myauth}
}

src_install() {
	default

	find "${D}" -name '*.la' -exec rm -f {} +

	# We disable example compilation above, and handle it here
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins src/examples/{*.c,*.policy*}
	fi

	# Need to keep a few directories around...
	diropts -m0700 -o root -g root
	keepdir /var/run/polkit-1
	keepdir /var/lib/polkit-1
}

pkg_postinst() {
	# Make sure that the user has consolekit sessions working so that the
	# 'allow_active' directive in polkit action policies works
	if has_version 'gnome-base/gdm' && ! has_version 'gnome-base/gdm[consolekit]'; then
		# If user has GDM installed, but USE=-consolekit, warn them
		ewarn "You have GDM installed, but it does not have USE=consolekit"
		ewarn "If you login using GDM, polkit authorizations will not work"
		ewarn "unless you enable USE=consolekit"
		einfo
	fi
	if has_version 'kde-base/kdm' && ! has_version 'kde-base/kdm[consolekit]'; then
		# If user has KDM installed, but USE=-consolekit, warn them
		ewarn "You have KDM installed, but it does not have USE=consolekit"
		ewarn "If you login using KDM, polkit authorizations will not work"
		ewarn "unless you enable USE=consolekit"
		einfo
	fi
	if ! has_version 'gnome-base/gdm[consolekit]' && \
		! has_version 'kde-base/kdm[consolekit]'; then
		# Inform user about the alternative method
		ewarn "If you don't use GDM or KDM for logging in,"
		ewarn "you must start your desktop environment (DE) as follows:"
		ewarn "	ck-launch-session \$STARTGUI"
		ewarn "Where \$STARTGUI is a DE-starting command such as 'gnome-session'."
		ewarn "You should add this to your ~/.xinitrc if you use startx."
	fi
}
