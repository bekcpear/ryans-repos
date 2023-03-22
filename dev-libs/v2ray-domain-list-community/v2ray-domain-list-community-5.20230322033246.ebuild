# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go

DESCRIPTION="Community managed domain list for V2Ray."
HOMEPAGE="https://github.com/v2fly/domain-list-community"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

SRC_URI="https://github.com/v2fly/domain-list-community/archive/refs/tags/${PV#5.}.tar.gz -> ${P}.tar.gz
	${GO_SUM_LIST_SRC_URI}"

S="${WORKDIR%/}/${PN#v2ray-}-${PV#5.}"

LICENSE="BSD MIT"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	!dev-libs/v2ray-domain-list-community-bin
	!<net-proxy/v2ray-core-4.38.3
"
BDEPEND=">=dev-lang/go-1.19"

src_compile() {
	go run ./
}

src_install() {
	insinto /usr/share/v2ray
	newins dlc.dat geosite.dat
}

pkg_postinst() {
	:
}
