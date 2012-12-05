EAPI="4"
inherit eutils
DESCRIPTION="Partition cloning tool"
HOMEPAGE="http://partclone.org"
SRC_URI="mirror://sourceforge/partclone/partclone-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="jfs xfs reiserfs reiser4 hfs +btrfs +fat +ntfs -vmfs"

RDEPEND="${common_depends}
	>=sys-fs/e2fsprogs-1.41.4
	fat? ( sys-fs/dosfstools )
	ntfs? ( sys-fs/ntfs3g )
	hfs? ( sys-fs/hfsutils )
	jfs? ( sys-fs/jfsutils )
	reiserfs? ( sys-fs/progsreiserfs )
	reiser4? ( sys-fs/reiser4progs )
	btrfs? ( sys-fs/btrfs-progs )
	xfs? ( sys-fs/xfsprogs )
	vmfs? ( sys-block/vmfs-tools )"
DEPEND=""

src_unpack()
{
	unpack ${A}
	cd ${S}
}

src_compile()
{
	local myconf
	myconf="${myconf} --enable-extfs --enable-ncursesw"
	use xfs && myconf="${myconf} --enable-xfs"
	use reiserfs && myconf="${myconf} --enable-reiserfs"
	use reiser4 && myconf="${myconf} --enable-reiser4"
	use btrfs && myconf="${myconf} --enable-btrfs"
	use hfs && myconf="${myconf} --enable-hfsp"
	use fat && myconf="${myconf} --enable-fat"
	use fat && myconf="${myconf} --enable-exfat"
	use ntfs && myconf="${myconf} --enable-ntfs"
	use xfs && myconf="${myconf} --enable-xfs"
	use vmfs && myconf="${myconf} --enable-vmfs"

	econf ${myconf} || die "econf failed"
	emake || die "make failed"
}

src_install()
{
	cd ${S}/src
	dosbin partclone.dd partclone.restore partclone.chkimg
	dosbin partclone.extfs
	use xfs && dosbin partclone.xfs
	use reiserfs && dosbin partclone.reiserfs
	use reiser4 && dosbin partclone.reiser4
	use btrfs && dosbin partclone.btrfs
	use hfs && dosbin partclone.hfsp
	use fat && dosbin partclone.fat
	use ntfs && dosbin partclone.ntfs
	use ntfs && dosbin partclone.ntfsfixboot
}

