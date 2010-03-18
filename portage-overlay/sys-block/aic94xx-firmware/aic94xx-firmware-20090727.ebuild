# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Firmware for aic94xx"
HOMEPAGE="http://www.kernel.org/pub/linux/kernel/people/jejb/"
SRC_URI="http://www.kernel.org/pub/linux/kernel/people/jejb/aic94xx-seq.fw"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# really depends on absolutely nothing
DEPEND=""
RDEPEND=""

src_unpack() {
	cp ${DISTDIR}/${A} .
}

src_compile() {
	true;
}

src_install() {
	insinto /lib/firmware
	doins aic94xx-seq.fw || die
}
