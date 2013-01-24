inherit eutils

DESCRIPTION="Outil Systeme Complet d'Assistance Reseau"
HOMEPAGE="http://oscar.crdp-lyon.fr/wiki/"
SRC_URI="http://www2.ac-lyon.fr/enseigne/electronique/oscar/livecd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=app-shells/bash-3.1"
RDEPEND="${DEPEND}"

src_install()
{
	dosbin "${S}/bin/cd_oscar" || die
	dodir /usr/share/oscar
	cp -a ${S}/* "${D}/usr/share/oscar/"
}

