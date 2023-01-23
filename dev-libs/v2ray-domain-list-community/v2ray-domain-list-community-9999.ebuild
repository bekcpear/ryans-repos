# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 go

DESCRIPTION="Community managed domain list for V2Ray."
HOMEPAGE="https://github.com/v2fly/domain-list-community"
EGIT_REPO_URI="https://github.com/v2fly/domain-list-community.git"

LICENSE="BSD MIT"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	!dev-libs/v2ray-domain-list-community-bin
	!<net-proxy/v2ray-core-4.38.3
"
BDEPEND=">=dev-lang/go-1.18"

src_unpack() {
	git-r3_src_unpack
	go_setup_vendor
}

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
