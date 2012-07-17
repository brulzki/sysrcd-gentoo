# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tigervnc/tigervnc-1.1.0-r7.ebuild,v 1.7 2012/06/29 18:40:46 maekke Exp $

EAPI="1"

inherit eutils toolchain-funcs multilib autotools

XSERVER_VERSION="1.12.3"
OPENGL_DIR="xorg-x11"

DESCRIPTION="Remote desktop viewer display system"
HOMEPAGE="http://www.tigervnc.org"
#SRC_URI="mirror://gentoo/${P}.tar.bz2
#	http://dev.gentoo.org/~armin76/dist/${P}.tar.bz2
SRC_URI="mirror://sourceforge/tigervnc/${P}.tar.gz
	mirror://gentoo/${PN}.png
	server? ( ftp://ftp.freedesktop.org/pub/xorg/individual/xserver/xorg-server-${XSERVER_VERSION}.tar.bz2
		mirror://gentoo/tigervnc-1.1.0_xorg-1.11.patch.bz2
		mirror://gentoo/tigervnc-1.1.0_xorg-1.12.patch.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc x86"
IUSE="nptl +opengl server +xorgmodule"

RDEPEND="virtual/jpeg
	sys-libs/zlib
	media-libs/freetype
	x11-libs/libSM
	x11-libs/libXtst
	app-admin/eselect-opengl
	server? (
		x11-libs/libXi
		x11-libs/libXfont
		x11-libs/libXmu
		x11-libs/libxkbfile
		x11-libs/libXrender
		x11-libs/pixman
		x11-apps/xauth
		x11-apps/xsetroot
		x11-misc/xkeyboard-config
		media-fonts/font-adobe-100dpi
		media-fonts/font-adobe-75dpi
		media-fonts/font-alias
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
		xorgmodule? ( ~x11-base/xorg-server-${XSERVER_VERSION} )
	)
	!net-misc/vnc
	!net-misc/tightvnc
	!net-misc/xf4vnc"
DEPEND="${RDEPEND}
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/nasm )
	>=x11-proto/inputproto-1.5
	>=x11-proto/xextproto-7.0.3
	>=x11-proto/xproto-7.0.13
	server?	(
		virtual/pkgconfig
		media-fonts/font-util
		x11-misc/util-macros
		x11-proto/bigreqsproto
		x11-proto/compositeproto
		x11-proto/damageproto
		x11-proto/dri2proto
		x11-proto/fixesproto
		x11-proto/fontsproto
		>=x11-proto/randrproto-1.2.99
		x11-proto/resourceproto
		x11-proto/scrnsaverproto
		x11-proto/trapproto
		x11-proto/videoproto
		x11-proto/xcmiscproto
		x11-proto/xineramaproto
		x11-proto/xf86bigfontproto
		x11-proto/xf86dgaproto
		x11-proto/xf86driproto
		x11-proto/xf86miscproto
		x11-proto/xf86vidmodeproto
		opengl? ( >=x11-proto/glproto-1.4.10 )
		>=media-libs/mesa-7.1
		>=x11-proto/renderproto-0.9.3
		x11-libs/libpciaccess
		>=x11-libs/xtrans-1.2.2
	)"

#S="${WORKDIR}/${PN}"

pkg_setup() {
	if ! use server ; then
		echo
		einfo "The 'server' USE flag will build tigervnc's server."
		einfo "If '-server' is chosen only the client is built to save space."
		einfo "Stop the build now if you need to add 'server' to USE flags.\n"
		ebeep
		epause 5
	else
		ewarn "Forcing on xorg-x11 for new enough glxtokens.h..."
		OLD_IMPLEM="$(eselect opengl show)"
		eselect opengl set ${OPENGL_DIR}
	fi
}

switch_opengl_implem() {
	# Switch to the xorg implementation.
	# Use new opengl-update that will not reset user selected
	# OpenGL interface ...
	echo
	eselect opengl set ${OLD_IMPLEM}
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	if use server ; then
		cp -r "${WORKDIR}"/xorg-server-${XSERVER_VERSION}/* unix/xserver
	fi

	eautoreconf
	cd unix

	if use server ; then
		epatch xserver110.patch
		epatch "${WORKDIR}"/${P}_xorg-1.11.patch
		epatch "${WORKDIR}"/${P}_xorg-1.12.patch
		cd xserver
		epatch "${FILESDIR}"/1.1.0-export_missing_symbol.patch
		epatch "${FILESDIR}"/1.1.0-gethomedir.patch
		epatch "${FILESDIR}"/1.1.0-xorg-1.12_fix.patch
		eautoreconf
	fi
}

src_compile() {
	econf --without-included-zlib --with-system-jpeg || die "econf failed"
	emake || die "emake failed"

	if use server ; then
		cd unix/xserver
		econf \
			--disable-xorg --disable-xnest --disable-xvfb --disable-dmx \
			--disable-xwin --disable-xephyr --disable-kdrive --with-pic \
			--disable-static --disable-xinerama \
			--disable-composite \
			--with-default-font-path=/usr/share/fonts/misc,/usr/share/fonts/75dpi,/usr/share/fonts/100dpi,/usr/share/fonts/TTF,/usr/share/fonts/Type1 \
			--enable-install-libxf86config \
			--enable-dri2 \
			--disable-config-dbus \
			--disable-config-hal \
			--with-xmlto=no \
			--disable-unit-tests \
			--disable-devel-docs \
			$(use_enable opengl glx) \
			$(use_enable nptl glx-tls) \
			|| die "econf server failed"
		emake || die "emake server failed"
	fi
}

src_install() {
	dodoc README.txt

	cd unix
	emake DESTDIR="${D}" install || die "emake install failed"
	newman vncviewer/vncviewer.man vncviewer.1

	newicon "${DISTDIR}"/tigervnc.png vncviewer.png
	make_desktop_entry vncviewer vncviewer vncviewer Network

	if use server ; then
		cd xserver/hw/vnc
		emake DESTDIR="${D}" install || die "emake install failed"
		! use xorgmodule && rm -rf "${D}"/usr/$(get_libdir)/xorg

		newconfd "${FILESDIR}"/${PN}.confd ${PN}
		newinitd "${FILESDIR}"/${PN}.initd ${PN}

		rm "${D}"/usr/$(get_libdir)/xorg/modules/extensions/libvnc.la
	else
		cd "${D}"
		for f in vncserver vncpasswd x0vncserver vncconfig; do
			rm usr/bin/$f
			rm usr/share/man/man1/$f.1
		done
	fi
}

pkg_postinst() {
	use server && switch_opengl_implem
}
