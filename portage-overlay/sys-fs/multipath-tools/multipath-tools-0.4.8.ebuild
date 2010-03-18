# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/multipath-tools/multipath-tools-0.4.8.ebuild,v 1.6 2009/03/07 22:56:00 josejx Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Device mapper target autoconfig"
HOMEPAGE="http://christophe.varoqui.free.fr/"
SRC_URI="http://christophe.varoqui.free.fr/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=sys-fs/lvm2-2.02.45
	sys-fs/udev
	sys-fs/sysfsutils
	dev-libs/libaio"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/0001-get-rid-of-arch-specific-ifdef-spaghettis.patch
	epatch "${FILESDIR}"/0002--libmultipath-filter_wwid-is-called-with-the-wron.patch
	epatch "${FILESDIR}"/0003--kpartx-Fix-udev-rules-for-dmraid.patch
	epatch "${FILESDIR}"/0004--kpartx-fix-extended-partition-handling.patch
	epatch "${FILESDIR}"/0005--kpartx-remove-partitions-in-reverse-order.patch
	epatch "${FILESDIR}"/0006--kpartx-documentation-fixes.patch
	epatch "${FILESDIR}"/0007--kpartx-remove-dead-code.patch
	epatch "${FILESDIR}"/0008-udev-as-of-0.124-doesn-t-support-scsi_id-s-anymor.patch
	epatch "${FILESDIR}"/0009-blacklist-cciss-devices.patch
	epatch "${FILESDIR}"/0010-fix-URL-to-FAQ.patch
	epatch "${FILESDIR}"/0011--kpartx-use-uint64_t-to-account-slices-start-size.patch
	epatch "${FILESDIR}"/0012--libmultipath-Update-discovery-to-work-with-new-sys.patch
}

src_compile() {
	emake -j1 CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dodir /sbin /usr/share/man/man8
	make DESTDIR="${D}" install || die "install failed"

	insinto /etc
	newins "${S}"/multipath.conf.annotated multipath.conf
	fperms 644 /etc/udev/rules.d/65-multipath.rules
	fperms 644 /etc/udev/rules.d/66-kpartx.rules
	# This is the monitoring daemon
	newinitd "${FILESDIR}"/rc-multipathd multipathd
	# This is the init script that fires the multipath addon for baselayout2
	newinitd "${FILESDIR}"/init.d-multipath multipath
	# Handle early-boot startup as well as shutdown of multipath devices
	insinto /lib/rcscripts/addons
	doins "${FILESDIR}"/multipath-start.sh
	doins "${FILESDIR}"/multipath-stop.sh

	dodoc multipath.conf.*
	dodoc AUTHOR ChangeLog FAQ README TODO
	docinto kpartx; dodoc kpartx/ChangeLog kpartx/README
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
	elog "If you need multipath on your system, you should ensure that a"
	elog "'multipath' entry is present in your RC_VOLUME_ORDER variable!"
	elog "If you use baselayout2, you must add 'multipath' into"
	elog "your boot runlevel!"
}
