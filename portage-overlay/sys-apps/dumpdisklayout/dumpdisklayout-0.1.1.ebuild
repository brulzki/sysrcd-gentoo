inherit eutils

DESCRIPTION="dump/restore disk layout (msdos-disklabel + lvm-layout) to a text file"
HOMEPAGE="http://www.sysresccd.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa mips ppc ppc64 sparc x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4.0
        >=sys-apps/pciutils-2.2.7
        >=sys-apps/iproute2-2.6.22
        >=sys-apps/ethtool-0.6
        >=sys-apps/usbutils-0.72"
RDEPEND="${DEPEND}"

src_install() 
{
	insinto /usr/lib/dumpdisklayout/modules/ || die
	doins "${FILESDIR}"/mod_*py || die
	doins "${FILESDIR}"/backup.py || die
	doins "${FILESDIR}"/restore.py || die
	dosbin "${FILESDIR}"/dumpsysinfo || die
	dosbin "${FILESDIR}"/dumpdisklayout || die
}

