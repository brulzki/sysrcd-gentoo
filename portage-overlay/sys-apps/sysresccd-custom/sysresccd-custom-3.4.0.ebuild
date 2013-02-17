DESCRIPTION="SystemRescueCd customization package"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="sysrcdfull"

inherit eutils

src_install()
{
	use sysrcdfull && cdtype="full" || cdtype="mini"
	echo "${cdtype}" >| sysresccd-type.txt
	insinto /usr/share/sysresccd
	doins sysresccd-type.txt
}
