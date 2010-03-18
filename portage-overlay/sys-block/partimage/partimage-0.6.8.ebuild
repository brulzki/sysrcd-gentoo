# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/partimage/partimage-0.6.7.ebuild,v 1.6 2009/05/22 16:38:16 flameeyes Exp $

WANT_AUTOMAKE="1.10"

inherit eutils flag-o-matic pam autotools

DESCRIPTION="Console-based application to efficiently save raw partition data to an image file."
HOMEPAGE="http://www.partimage.org/"
SRC_URI="mirror://sourceforge/partimage/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="ssl nologin nls pam static"

DEPEND="virtual/libc
	>=sys-libs/zlib-1.1.4
	>=dev-libs/newt-0.52.2
	app-arch/bzip2
	>=sys-libs/slang-1.4
	nls? ( sys-devel/gettext )
	ssl? ( >=dev-libs/openssl-0.9.6g )"

RDEPEND="!static? ( virtual/libc
		>=sys-libs/zlib-1.1.4
		>=dev-libs/lzo-1.08
		>=dev-libs/newt-0.52.2
		app-arch/bzip2
		>=sys-libs/slang-1.4
		nls? ( sys-devel/gettext )		ssl? ( >=dev-libs/openssl-0.9.6g )
		pam? ( virtual/pam )
	)"

PARTIMAG_GROUP_GID=91
PARTIMAG_USER_UID=91
PARTIMAG_GROUP_NAME=partimag
PARTIMAG_USER_NAME=partimag
PARTIMAG_USER_SH=-1
PARTIMAG_USER_HOMEDIR=/var/log/partimage
PARTIMAG_USER_GROUPS=partimag

pkg_setup() {
	# Now add users if needed
	enewgroup ${PARTIMAG_GROUP_NAME} ${PARTIMAG_GROUP_GID}
	enewuser ${PARTIMAG_USER_NAME} ${PARTIMAG_USER_UID} ${PARTIMAG_USER_SH} ${PARTIMAG_USER_HOMEDIR} ${PARTIMAG_USER_GROUPS}
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	#epatch "${FILESDIR}"/${PN}-0.6.4-save_file_and_rest_file_actions.patch || die
	#epatch "${FILESDIR}"/${PN}-0.6.6-not_install_info.patch || die
	#epatch "${FILESDIR}"/${PN}-0.6.4-chown.patch || die
	#epatch "${FILESDIR}"/${PN}-0.6.6-disable_header_check.patch || die
	epatch "${FILESDIR}"/${PN}-0.6.7-datadir-path.patch || die
	#epatch "${FILESDIR}"/${P}-gcc43.patch
	#epatch "${FILESDIR}"/${P}+glibc-2.10.patch
}

src_compile() {
	filter-flags -fno-exceptions
	use ppc && append-flags -fsigned-char

	local myconf
	use nologin && myconf="${myconf} --disable-login"
	if use static
	then
		use pam && ewarn "pam and static compilation are mutually exclusive - using static and ignoring pam"
	else
		myconf="${myconf} `use_enable pam`"
	fi
	econf \
		${myconf} \
		--sysconfdir=/etc \
		`use_enable ssl` \
		`use_enable nls` \
		`use_enable static all-static` \
		|| die "econf failed"

	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" \
		MKINSTALLDIRS=/usr/share/automake-1.10/mkinstalldirs install || die

	keepdir /var/log/partimage

	insinto /etc/partimaged; doins "${FILESDIR}"/servercert.cnf || die

	# init.d / conf.d
	newinitd "${FILESDIR}"/${PN}d.init ${PN}d || die
	newconfd "${FILESDIR}"/${PN}d.conf ${PN}d || die

	doman "${FILESDIR}"/{partimage.1,partimaged.8,partimagedusers.5} || die
	#dodoc AUTHORS BUGS ChangeLog INSTALL README* TODO partimage.lsm || die

	# pam
	if use pam
	then
		newpamd "${FILESDIR}"/partimaged.pam partimaged || die
	fi
}

# vars for SSL stuff
confdir="${ROOT}etc/partimaged"
privkey="${confdir}/partimaged.key"
cnf="${confdir}/servercert.cnf"
csr="${confdir}/partimaged.csr"
cert="${confdir}/partimaged.cert"

pkg_config() {
	if use ssl; then
		ewarn "Please customize /etc/partimaged/servercert.cnf before you continue!"
		ewarn "Press Ctrl-C to break now for it, or press enter to continue."
		read
		if [ ! -f ${privkey} ]; then
			einfo "Generating unencrypted private key: ${privkey}"
			openssl genrsa -out ${privkey} 1024  || die "Failed!"
		else
			einfo "Private key already exists: ${privkey}"
		fi
		if [ ! -f ${csr} ]; then
			einfo "Generating certificate request: ${csr}"
			openssl req -new -x509 -outform PEM -out ${csr} -key ${privkey} -config ${cnf} || die "Failed!"
		else
			einfo "Certificate request already exists: ${csr}"
		fi
		if [ ! -f ${cert} ]; then
			einfo "Generating self-signed certificate: ${cert}"
			openssl x509 -in ${csr} -out ${cert} -signkey ${privkey} || die "Failed!"
		else
			einfo "Self-signed certifcate already exists: ${cert}"
		fi
		einfo "Setting permissions"
		partimagesslperms || die "Failed!"
		einfo "Done"
	else
		einfo "SSL is disabled, not building certificates"
	fi
}

partimagesslperms() {
	local ret=0
	chmod 600 ${privkey} 2>/dev/null
	ret=$((${ret}+$?))
	chown partimag:0 ${privkey} 2>/dev/null
	ret=$((${ret}+$?))
	chmod 644 ${cert} ${csr} 2>/dev/null
	ret=$((${ret}+$?))
	chown root:0 ${cert} ${csr} 2>/dev/null
	ret=$((${ret}+$?))
	return $ret
}

pkg_postinst() {
	if use ssl; then
		einfo "To create the required SSL certificates, please do:"
		einfo "emerge  --config =${PF}"
		# force a permmissions fixup
		partimagesslperms
		return 0
	fi
	chown partimag:0 /etc/partimaged/partimagedusers || die
}

