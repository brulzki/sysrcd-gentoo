# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/www/viewcvs.gentoo.org/raw_cvs/gentoo-x86/sys-kernel/genkernel/genkernel-3.4.10-r1.ebuild,v 1.1 2008/06/06 16:12:20 wolf31o2 Exp $

# genkernel-9999        -> latest SVN
# genkernel-9999.REV    -> use SVN REV
# genkernel-VERSION     -> normal genkernel release

VERSION_BUSYBOX='1.19.4'
VERSION_DMAP='1.02.22'
VERSION_DMRAID='1.0.0.rc16'
VERSION_E2FSPROGS='1.40.11'
VERSION_LVM='2.02.56'

MY_HOME="http://dev.gentoo.org/~wolf31o2"
RH_HOME="ftp://sources.redhat.com/pub"
DM_HOME="http://people.redhat.com/~heinzm/sw/dmraid/src"
BB_HOME="http://www.busybox.net/downloads"

COMMON_URI="${DM_HOME}/dmraid-${VERSION_DMRAID}.tar.bz2
		${DM_HOME}/old/dmraid-${VERSION_DMRAID}.tar.bz2
		${RH_HOME}/lvm2/LVM2.${VERSION_LVM}.tgz
		${RH_HOME}/lvm2/old/LVM2.${VERSION_LVM}.tgz
		${RH_HOME}/dm/device-mapper.${VERSION_DMAP}.tgz
		${RH_HOME}/dm/old/device-mapper.${VERSION_DMAP}.tgz
		${BB_HOME}/busybox-${VERSION_BUSYBOX}.tar.bz2
		mirror://sourceforge/e2fsprogs/e2fsprogs-${VERSION_E2FSPROGS}.tar.gz"

if [[ ${PV} == 9999* ]]
then
	[[ ${PV} == 9999.* ]] && ESVN_UPDATE_CMD="svn up -r ${PV/9999./}"
	ESVN_REPO_URI="svn://anonsvn.gentoo.org/genkernel/trunk"
	inherit subversion bash-completion eutils
	S=${WORKDIR}/trunk
	SRC_URI="${COMMON_URI}"
else
	inherit bash-completion eutils
	SRC_URI="mirror://gentoo/${P}.tar.bz2
		${MY_HOME}/sources/genkernel/${P}.tar.bz2
		${COMMON_URI}"
fi

DESCRIPTION="Gentoo automatic kernel building scripts"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"
RESTRICT=""
KEYWORDS="amd64 x86"
IUSE="ibm selinux"

DEPEND="sys-fs/e2fsprogs
	selinux? ( sys-libs/libselinux )"
RDEPEND="${DEPEND} app-arch/cpio"

src_unpack() 
{
	if [[ ${PV} == 9999* ]] ; then
		subversion_src_unpack
	else
		unpack ${P}.tar.bz2
	fi

	# ---- do not compile devmapper, it's part of lvm2
	cd "${S}"
	epatch ${FILESDIR}/genkernel-3.4.10-sysrcd.patch

	#cp "${FILESDIR}/gen_compile.sh" gen_compile.sh
	use selinux && sed -i 's/###//g' gen_compile.sh

	# ---- enable the following options in busybox
	optenabled=(WGET FEATURE_WGET_STATUSBAR MD5SUM VI FEATURE_VI_YANKMARK \
					FEATURE_VI_SEARCH AWK ROUTE TFTP FEATURE_TFTP_GET IP FEATURE_IP_ADDRESS \
					FEATURE_IP_LINK FEATURE_IP_ROUTE IPADDR IPLINK IPROUTE NSLOOKUP \
					USE_BB_SHADOW USE_BB_PWD_GRP FEATURE_GREP_EGREP_ALIAS FINDFS TUNE2FS \
					NAMEIF FEATURE_MDEV_CONF TELNET NC STAT FEATURE_STAT_FORMAT)
	optdisabled=(NFSMOUNT FEATURE_MOUNT_NFS)

	for arch in x86 x86_64 ia64 mips alpha ppc64 sparc parisc64 sparc64 parisc um ppc 
	do
		for curopt in ${optenabled[*]}
		do
			sed -i -e "s/# CONFIG_${curopt} is not set/CONFIG_${curopt}=y/" $arch/busy-config
			if ! cat $arch/busy-config | grep -q "CONFIG_${curopt}=y"
			then
				echo "CONFIG_${curopt}=y" >> $arch/busy-config
			fi
		done
		for curopt in ${optdisabled[*]}
		do
			sed -i -e "s/CONFIG_${curopt}=y/#CONFIG_${curopt} is not set/" $arch/busy-config
		done
	done

	# ---- copy the modules
	for arch in x86 x86_64
	do
		cp "${FILESDIR}/modules_load" $arch/modules_load
	done
}

src_install() 
{
	# This block updates genkernel.conf
	sed -e "s:VERSION_DMAP:$VERSION_DMAP:" \
		-e "s:VERSION_DMRAID:$VERSION_DMRAID:" \
		-e "s:VERSION_E2FSPROGS:$VERSION_E2FSPROGS:" \
		-e "s:VERSION_LVM:$VERSION_LVM:" \
		-e "s:VERSION_BUSYBOX:$VERSION_BUSYBOX:" \
		"${S}"/genkernel.conf > "${T}"/genkernel.conf \
		|| die "Could not adjust versions"
	insinto /etc
	doins "${T}"/genkernel.conf || die "doins genkernel.conf"

	doman genkernel.8 || die "doman"
	dodoc AUTHORS ChangeLog README TODO || die "dodoc"

	dobin genkernel || die "dobin genkernel"

	rm -f genkernel genkernel.8 AUTHORS ChangeLog README TODO genkernel.conf

	insinto /usr/share/genkernel
	doins -r "${S}"/* || die "doins"
	use ibm && cp "${S}"/ppc64/kernel-2.6-pSeries "${S}"/ppc64/kernel-2.6 || \
		cp "${S}"/ppc64/kernel-2.6.g5 "${S}"/ppc64/kernel-2.6

	# Copy files to /var/cache/genkernel/src
	elog "Copying files to /var/cache/genkernel/src..."
	mkdir -p "${D}"/var/cache/genkernel/src
	cp -f \
		"${DISTDIR}"/dmraid-${VERSION_DMRAID}.tar.bz2 \
		"${DISTDIR}"/LVM2.${VERSION_LVM}.tgz \
		"${DISTDIR}"/device-mapper.${VERSION_DMAP}.tgz \
		"${DISTDIR}"/e2fsprogs-${VERSION_E2FSPROGS}.tar.gz \
		"${DISTDIR}"/busybox-${VERSION_BUSYBOX}.tar.bz2 \
		"${D}"/var/cache/genkernel/src || die "Copying distfiles..."

	dobashcompletion "${FILESDIR}"/genkernel.bash
}

