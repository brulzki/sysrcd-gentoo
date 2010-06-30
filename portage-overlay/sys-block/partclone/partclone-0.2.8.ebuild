inherit eutils

DESCRIPTION="Partition cloning tool"
HOMEPAGE="http://partclone.org"
SRC_URI="mirror://sourceforge/partclone/partclone-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="xfs reiserfs reiser4 hfs fat ntfs"

RDEPEND="${common_depends}
	>=sys-fs/e2fsprogs-1.41.4
	fat? ( sys-fs/dosfstools )
	ntfs? ( sys-fs/ntfsprogs )
	hfs? ( sys-fs/hfsutils )
	jfs? ( sys-fs/jfsutils )
	reiserfs? ( sys-fs/progsreiserfs )
	reiser4? ( sys-fs/reiser4progs )
	xfs? ( sys-fs/xfsprogs )"
DEPEND=""

src_unpack()
{
	unpack ${A}
	#mv partclone partclone-${PV}
	cd ${S}
}

src_compile() 
{
	local myconf
	myconf="${myconf} --enable-extfs --enable-ncursesw"
	use xfs && myconf="${myconf} --enable-xfs"
	use reiserfs && myconf="${myconf} --enable-reiserfs"
	use reiser4 && myconf="${myconf} --enable-reiser4"
	use hfs && myconf="${myconf} --enable-hfsp"
	use fat && myconf="${myconf} --enable-fat"
	use ntfs && myconf="${myconf} --enable-ntfs"
	use xfs && myconf="${myconf} --enable-xfs"

	econf ${myconf} || die "econf failed"
	emake || die "make failed"
}

src_install()
{
	#emake install || die "make install failed"
	#emake DIST_ROOT="${D}" install || die "make install failed"
	cd ${S}/src
	dosbin partclone.dd partclone.restore partclone.chkimg
	dosbin partclone.extfs
	use xfs && dosbin partclone.xfs
	use reiserfs && dosbin partclone.reiserfs
	use reiser4 && dosbin partclone.reiser4
	use hfs && dosbin partclone.hfsp
	use fat && dosbin partclone.fat
	use ntfs && dosbin partclone.ntfs
	use ntfs && dosbin partclone.ntfsfixboot
}

