# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/tar/tar-1.21-r1.ebuild,v 1.1 2008/12/29 10:03:44 vapier Exp $

inherit flag-o-matic eutils

DESCRIPTION="Use this to make tarballs :)"
HOMEPAGE="http://www.gnu.org/software/tar/"
SRC_URI="http://ftp.gnu.org/gnu/tar/${P}.tar.gz
	ftp://alpha.gnu.org/gnu/tar/${P}.tar.gz
	mirror://gnu/tar/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="nls static userland_GNU"

RDEPEND=""
DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.10.35 )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/tar-1.14-loneZeroWarning.patch
	epatch "${FILESDIR}"/tar-1.15.1-vfatTruncate.patch
	epatch "${FILESDIR}"/tar-1.19-xattrs.patch
	epatch "${FILESDIR}"/tar-1.19-xattrs-conf.patch
	epatch "${FILESDIR}"/tar-1.17-wildcards.patch
	
	if ! use userland_GNU ; then
		sed -i \
			-e 's:/backup\.sh:/gbackup.sh:' \
			scripts/{backup,dump-remind,restore}.in \
			|| die "sed non-GNU"
	fi
}

src_compile() {
	local myconf
	use static && append-ldflags -static
	use userland_GNU || myconf="--program-prefix=g"
	# Work around bug in sandbox #67051
	gl_cv_func_chown_follows_symlink=yes \
	econf \
		--enable-backup-scripts \
		--bindir=/bin \
		--libexecdir=/usr/sbin \
		$(use_enable nls) \
		${myconf} || die
	emake || die "emake failed"
}

src_install() {
	local p=""
	use userland_GNU || p=g

	emake DESTDIR="${D}" install || die "make install failed"

	if [[ -z ${p} ]] ; then
		# a nasty yet required piece of baggage
		exeinto /etc
		doexe "${FILESDIR}"/rmt || die
	fi

	dodoc AUTHORS ChangeLog* NEWS README* PORTS THANKS
	newman "${FILESDIR}"/tar.1 ${p}tar.1
	mv "${D}"/usr/sbin/${p}backup{,-tar}
	mv "${D}"/usr/sbin/${p}restore{,-tar}

	rm -f "${D}"/usr/$(get_libdir)/charset.alias
}
