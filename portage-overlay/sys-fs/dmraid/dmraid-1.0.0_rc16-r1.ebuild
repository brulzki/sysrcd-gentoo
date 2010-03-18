# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/dmraid/dmraid-1.0.0_rc16-r1.ebuild,v 1.1 2009/12/01 17:03:54 tommy Exp $

EAPI="2"

inherit linux-info flag-o-matic

MY_PV=${PV/_/.}

DESCRIPTION="Device-mapper RAID tool and library"
HOMEPAGE="http://people.redhat.com/~heinzm/sw/dmraid/"
SRC_URI="http://people.redhat.com/~heinzm/sw/dmraid/src/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static selinux"

RDEPEND="|| ( >=sys-fs/lvm2-2.02.45
		sys-fs/device-mapper )
	selinux? ( sys-libs/libselinux
		   sys-libs/libsepol )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}/${MY_PV}

pkg_setup() {
	if kernel_is lt 2 6 ; then
		ewarn "You are using a kernel < 2.6"
		ewarn "DMraid uses recently introduced Device-Mapper features."
		ewarn "These might be unavailable in the kernel you are running now."
	fi
	if use static && use selinux ; then
		eerror "ERROR - cannot compile static with libselinux / libsepol"
		die "USE flag conflicts."
	fi
}

src_prepare() {
	epatch	"${FILESDIR}"/${P}-undo-p-rename.patch \
		"${FILESDIR}"/${P}-return-all-sets.patch \
		"${FILESDIR}"/${PN}-destdir-fix.patch \
		"${FILESDIR}"/${P}-as-needed.patch

	# archive the patched source for use with genkernel
	cd "${WORKDIR}"
	tar -jcf ${PN}-${MY_PV}-prepatched.tar.bz2 ${PN} || die
}

src_configure() {
	econf \
		$(use_enable static static_link) \
		$(use_enable selinux libselinux) \
		$(use_enable selinux libsepol)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CHANGELOG README TODO KNOWN_BUGS doc/* || die "dodoc failed"
	insinto /usr/share/${PN}
	doins "${WORKDIR}"/${PN}-${MY_PV}-prepatched.tar.bz2 || die
}

pkg_postinst() {
	elog "For booting Gentoo from Device-Mapper RAID you can use Genkernel."
	elog " "
	elog "Genkernel will generate the kernel and the initrd with a statically "
	elog "linked dmraid binary (its own version which may not be the same as this version):"
	elog "\t emerge -av sys-kernel/genkernel"
	elog "\t genkernel --dmraid all"
	elog " "
	elog "If you would rather use this version of DMRAID with Genkernel, update the following"
	elog "in /etc/genkernel.conf:"
	elog "\t DMRAID_VER=\"${MY_PV}\""
	elog "\t DMRAID_SRCTAR=\"/usr/share/${PN}/${PN}-${MY_PV}-prepatched.tar.bz2\""
	elog " "
	ewarn "DMRAID should be safe to use, but no warranties can be given"
}
