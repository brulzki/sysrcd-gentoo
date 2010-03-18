inherit eutils

DESCRIPTION="deals with braindeadness with moving NTFS filesystems"
HOMEPAGE="http://www.linux-ntfs.org/doku.php?id=contrib:ntfsreloc"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

#DEPEND=""
#RDEPEND="${DEPEND}"

src_unpack()
{
	mkdir ${S}
	cp ${FILESDIR}/* ${S}
}

src_compile()
{
	cd ${S}
	gcc -o ntfsreloc ntfsreloc.c || die "emake failed"
}

src_install()
{
	dosbin ${S}/ntfsreloc
}
