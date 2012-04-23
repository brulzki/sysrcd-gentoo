# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/zfs-fuse/zfs-fuse-0.6.9-r1.ebuild,v 1.4 2010/08/10 10:31:00 ssuominen Exp $

EAPI=2
inherit bash-completion

DESCRIPTION="An implementation of the ZFS filesystem for FUSE/Linux"
HOMEPAGE="http://zfs-fuse.net/"
SRC_URI="http://zfs-fuse.net/releases/${PV}/source-tar-ball -> ${P}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="dev-libs/libaio
	dev-libs/openssl
	sys-fs/fuse
	sys-libs/zlib"
DEPEND="${RDEPEND}
	dev-util/scons
	sys-apps/acl
	sys-apps/attr"

S=${WORKDIR}/${P}/src

src_prepare() {
	sed -i \
		-e '/LINKFLAGS/s:-s::' \
		-e '/CCFLAGS/s:-s -O2::' \
		SConstruct || die

	sed -i \
		-e 's:../zdb/zdb:/usr/sbin/zdb:' \
		cmd/ztest/ztest.c || die
}

src_compile() {
	local _debug=0
	use debug && _debug=2

	scons debug=${_debug} || die
}

src_install() {
	scons \
		install_dir="${D}/usr/sbin" \
		man_dir="${D}/usr/share/man/man8" \
		cfg_dir="${D}/etc/zfs" \
		install || die

	insinto /etc/zfs
	doins ../contrib/zfsrc || die

	keepdir /var/{lock,run}/zfs
	fowners root.disk /var/{lock,run}/zfs

	doinitd "${FILESDIR}"/${PN}

	dodoc ../{BUGS,CHANGES,HACKING,README*,STATUS,TESTING,TODO}

	dobashcompletion ../contrib/zfs_completion.bash ${PN}
}
