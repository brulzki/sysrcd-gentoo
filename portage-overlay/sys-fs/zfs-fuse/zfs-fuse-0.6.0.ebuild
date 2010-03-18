# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="doc"

inherit eutils
	
DESCRIPTION="An implementation of the ZFS filesystem for FUSE/Linux"
HOMEPAGE="http://www.wizy.org/wiki/ZFS_on_FUSE"
SRC_URI="http://download.berlios.de/zfs-fuse/zfs-fuse-${PV}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=">=sys-libs/glibc-2.3.3
	>=dev-util/scons-0.96.1
	>=dev-libs/libaio-0.3.0
	>=sys-fs/fuse-2.6.1"

RDEPEND=">=sys-fs/fuse-2.6.1"

S=${WORKDIR}/${P}/src

src_unpack() {
	unpack ${A}
	cd ${S}
}	

src_compile() {

	scons || die "Make failed"
}

src_install() {
	
	mv cmd/ztest/ztest cmd/ztest/run-ztest || die "Error renaming"
	mv cmd/ztest/runtest.sh cmd/ztest/ztest || die "Error renaming"
	
	dosbin cmd/ztest/run-ztest || die "Error installing"	
	dosbin cmd/ztest/ztest || die "Error installing"
	
	mv zfs-fuse/zfs-fuse zfs-fuse/run-zfs-fuse || die "Error renaming"
	mv zfs-fuse/run.sh zfs-fuse/zfs-fuse || die "Error renaming"

	dobin zfs-fuse/run-zfs-fuse || die "Error installing"
	dobin zfs-fuse/zfs-fuse || die "Error installing"	

	dosbin cmd/zfs/zfs || die "Error installing"
	dosbin cmd/zpool/zpool || die "Error installing"
	dosbin cmd/zdb/zdb || die "Error installing"	 

	cd ${WORKDIR}/${P} || die "Error installing"
	
	dodoc CHANGES || die "Error installing"

	if use doc; then
  		dodoc {INSTALL,TODO,STATUS,TESTING,HACKING,BUGS} || die "Error installing"
	fi
		
}

pkg_postinst() {	

	einfo  
	einfo "To debug and play with ZFS-FUSE make sure you have a recent 2.6.xx"
	einfo "series kernel with the FUSE module compiled in OR built as a" 
	einfo "kernel module."
	einfo
	einfo "You can start the ZFS-FUSE daemon by running"
    einfo
    einfo "     /usr/bin/run-zfs-fuse"
    einfo
	einfo "as root from the command line. "
	einfo	
	einfo "For additional ZFS related commands I recommend the ZFS admin"
	einfo "guide. http://opensolaris.org/os/community/zfs/docs/zfsadmin.pdf"
	einfo 
	einfo "Don't forget this is an beta-quality release. Testing has been"
	einfo "very limited so please make sure you backup any important data."
	einfo 
	einfo "If you have any problems with zfs-fuse please visit the ZFS-FUSE." 
	einfo "website at http://developer.berlios.de/projects/zfs-fuse/"
	einfo 
	einfo "Thanks for testing."
	einfo 

	ewarn "This is an unofficial Gentoo ebuild. Please do NOT file bugs against" 
	ewarn "it on bugs.gentoo.org, they will be disregarded. Many thanks."
	ewarn
}
