# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 go-module

DESCRIPTION="GeoIP generator for V2Ray."
HOMEPAGE="https://github.com/v2fly/geoip http://www.maxmind.com/"
EGIT_REPO_URI="https://github.com/v2fly/geoip.git"

LICENSE="Apache-2.0 BSD CC-BY-SA-4.0 ISC MIT"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.19:="

src_unpack() {
	git-r3_src_unpack
	local -a hps
	if [[ -n HTTP_PROXY ]]; then
		hps+=( HTTP_PROXY )
	elif [[ -n http_proxy ]]; then
		hps+=( http_proxy )
	fi
	if [[ -n HTTPS_PROXY ]]; then
		hps+=( HTTPS_PROXY )
	elif [[ -n https_proxy ]]; then
		hps+=( https_proxy )
	fi
	for hp in "${hps[@]}"; do
		if [[ -n ${!hp} ]] && [[ ${!hp} =~ ^socks5h:// ]]; then
			ewarn "go does not support 'socks5h://' schema for '${hp}', fallback to 'socks5://' schema"
			eval "export ${hp}=${!hp#socks5h}socks5"
		fi
	done
	go-module_live_vendor
}

src_compile() {
	go build -v -work -o ${PN} -trimpath ./main.go || die
}

src_install() {
	exeinto /usr/bin
	doexe ${PN}
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
