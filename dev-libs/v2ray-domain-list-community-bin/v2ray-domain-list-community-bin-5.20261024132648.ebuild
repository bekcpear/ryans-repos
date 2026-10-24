# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Community managed domain list for V2Ray."
HOMEPAGE="https://github.com/v2fly/domain-list-community"
if [[ ${PV} == *9999 ]]; then
	PROPERTIES="live"
else
	SRC_URI="https://github.com/v2fly/domain-list-community/releases/download/${PV#5.}/dlc.dat.xz -> ${P}.dat.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	!dev-libs/v2ray-domain-list-community
	!<net-proxy/v2ray-core-4.38.3
"
BDEPEND=""

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		wget "https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat" || die
		wget "https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat.sha256sum" || die
		sha256sum -c dlc.dat.sha256sum || die "check sha256sum for 'dlc.dat' failed"
	else
		default
		mv ${P}.dat dlc.dat || die
	fi
}

src_install() {
	insinto /usr/share/v2ray
	newins dlc.dat geosite.dat
}
