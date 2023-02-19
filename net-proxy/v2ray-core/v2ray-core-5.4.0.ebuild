# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go systemd

DESCRIPTION="A platform for building proxies to bypass network restrictions."
HOMEPAGE="https://github.com/v2fly/v2ray-core"

SRC_URI="https://github.com/v2fly/v2ray-core/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

BDEPEND="
	>dev-lang/go-1.18.9999:=
	<=dev-lang/go-1.20.9999:=
"
DEPEND=""
RDEPEND="
	dev-libs/v2ray-geoip-bin
	|| (
		dev-libs/v2ray-domain-list-community-bin
		dev-libs/v2ray-domain-list-community
	)
"

GO_TARGET_PKGS="./main -> v2ray"

src_prepare() {
	sed -i 's|/usr/local/bin|/usr/bin|;s|/usr/local/etc|/etc|' release/config/systemd/system/*.service || die
	sed -i '/^User=/s/nobody/v2ray/;/^User=/aDynamicUser=true' release/config/systemd/system/*.service || die
	default
}

src_install() {
	go_src_install

	insinto /etc/v2ray
	doins release/config/*.json
	doins "${FILESDIR}/example.client.v4.json"

	newinitd "${FILESDIR}/v2ray.initd" v2ray
	newconfd "${FILESDIR}/v2ray.confd" v2ray

	systemd_newunit release/config/systemd/system/v2ray.service v2ray.service
	systemd_newunit release/config/systemd/system/v2ray@.service v2ray@.service
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		if ! systemd_is_booted; then
			elog "The default openrc service is located at ${EROOT}/etc/init.d/v2ray,"
			elog "and the corresponding default config file is ${EROOT}/etc/v2ray/config.json."
			elog "You can make a symlink file to the service with the format 'v2ray.XX' to"
			elog "specify a different config file 'config.XX.json', 'XX' are any alnum characters."
			elog "Please also read ${EROOT}/etc/conf.d/v2ray."
		fi
	fi
}
