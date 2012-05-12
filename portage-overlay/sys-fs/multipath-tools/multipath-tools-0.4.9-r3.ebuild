# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/multipath-tools/multipath-tools-0.4.9-r3.ebuild,v 1.1 2011/11/30 04:30:50 vapier Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Device mapper target autoconfig"
HOMEPAGE="http://christophe.varoqui.free.fr/"
SRC_URI="http://christophe.varoqui.free.fr/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="|| (
		>=sys-fs/lvm2-2.02.45
		>=sys-fs/device-mapper-1.00.19-r1
	)
	>=sys-fs/udev-124
	dev-libs/libaio
	sys-libs/readline
	!<sys-apps/baselayout-2"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_prepare() {
	 epatch "${FILESDIR}"/${PN}-0.4.9-build.patch
	 epatch "${FILESDIR}"/${PN}-0.4.9-buffer-overflows.patch
	 epatch "${FILESDIR}"/${PN}-0.4.8-kparted-ext-partitions.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dodir /sbin /usr/share/man/man8
	emake DESTDIR="${D}" install || die

	insinto /etc
	newins "${S}"/multipath.conf.annotated multipath.conf
	fperms 644 /etc/udev/rules.d/65-multipath.rules
	fperms 644 /etc/udev/rules.d/66-kpartx.rules
	newinitd "${FILESDIR}"/rc-multipathd multipathd || die
	newinitd "${FILESDIR}"/multipath.rc multipath || die

	dodoc multipath.conf.* AUTHOR ChangeLog FAQ README TODO
	docinto kpartx
	dodoc kpartx/ChangeLog kpartx/README
}

pkg_preinst() {
	# The dev.d script was previously wrong and is now removed (the udev rules
	# file does the job instead), but it won't be removed from live systems due
	# to cfgprotect.
	# This should help out a little...
	if [[ -e ${ROOT}/etc/dev.d/block/multipath.dev ]] ; then
		mkdir -p "${D}"/etc/dev.d/block
		echo "# Please delete this file. It is obsoleted by /etc/udev/rules.d/65-multipath.rules" \
			> "${D}"/etc/dev.d/block/multipath.dev
	fi
}

pkg_postinst() {
	elog "If you need multipath on your system, you must"
	elog "add 'multipath' into your boot runlevel!"
}
