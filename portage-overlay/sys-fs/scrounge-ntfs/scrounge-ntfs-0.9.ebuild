inherit eutils

DESCRIPTION="Data recovery program for NTFS file systems"
HOMEPAGE="http://memberwebs.com/stef/software/scrounge/"
SRC_URI="http://memberwebs.com/stef/software/scrounge/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_compile() 
{
	cd "${P}"
	econf || die "Configure failed"
	emake || die "Make failed"
}

src_install() 
{
	cd "${P}"
	strip src/scrounge-ntfs
	make DESTDIR="${D}" install || die "Install failed"
}

