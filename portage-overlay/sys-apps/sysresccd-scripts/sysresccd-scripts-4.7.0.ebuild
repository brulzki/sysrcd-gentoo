inherit eutils

DESCRIPTION="admin scripts provided with SystemRescueCd"
HOMEPAGE="http://www.system-rescue-cd.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa mips ppc ppc64 sparc x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4.0
        >=app-shells/bash-3.1"
RDEPEND="${DEPEND}"

src_install()
{
	dosbin "${FILESDIR}"/sysresccd-custom || die
	dosbin "${FILESDIR}"/sysresccd-usbstick || die
	dosbin "${FILESDIR}"/sysresccd-backstore || die
	dosbin "${FILESDIR}"/sysresccd-pkgstats || die
	dosbin "${FILESDIR}"/sysresccd-cleansys || die
	dosbin "${FILESDIR}"/autorun || die
	dosbin "${FILESDIR}"/knx-hdinstall || die
	dosbin "${FILESDIR}"/mountsys || die
	dosbin "${FILESDIR}"/sysreport || die
}
