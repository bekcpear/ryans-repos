# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 go

DESCRIPTION="GeoIP generator for V2Ray."
HOMEPAGE="https://github.com/v2fly/geoip http://www.maxmind.com/"
EGIT_REPO_URI="https://github.com/v2fly/geoip.git"

LICENSE="Apache-2.0 BSD CC-BY-SA-4.0 ISC MIT"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.19:="
GO_TARGET_PKGS=". -> $PN"

src_unpack() {
	git-r3_src_unpack
	go_setup_vendor
}

src_install() {
	go_src_install
	insinto /usr/share/${PN}
	doins config-example.json
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog
		elog "run:"
		elog "  ${PN} -help"
		elog "to check the usage."
		elog
		elog "The original data files can be downloaded from:"
		elog "https://dev.maxmind.com/geoip/geoip2/geolite2/"
		elog "You need to sign up a maxmind account."
		elog
	fi
}
