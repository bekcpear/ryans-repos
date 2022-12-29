# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd unpacker

DESCRIPTION="A platform for building proxies to bypass network restrictions."
HOMEPAGE="https://github.com/v2fly/v2ray-core"

SRC_URI="
	amd64? ( https://github.com/v2fly/v2ray-core/releases/download/v${PV}/v2ray-linux-64.zip -> ${P}_amd64.zip )
	arm64? ( https://github.com/v2fly/v2ray-core/releases/download/v${PV}/v2ray-linux-arm64-v8a.zip -> ${P}_arm64.zip )
	riscv? ( https://github.com/v2fly/v2ray-core/releases/download/v${PV}/v2ray-linux-riscv64.zip -> ${P}_riscv.zip )
"

LICENSE="CC-BY-SA-4.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE="+separate-geo tiny-geoip tool"
REQUIRED_USE="separate-geo? ( !tiny-geoip )" #TODO remove this restriction later

RDEPEND="
	!net-proxy/v2ray-core
	!separate-geo? (
		!dev-libs/v2ray-geoip-bin
		!dev-libs/v2ray-domain-list-community-bin
		!dev-libs/v2ray-domain-list-community
	)
	separate-geo? (
		dev-libs/v2ray-geoip-bin
		|| (
			dev-libs/v2ray-domain-list-community-bin
			dev-libs/v2ray-domain-list-community
		)
	)
"
BDEPEND="app-arch/unzip"

QA_PREBUILT="
	/usr/bin/v2ray
	/usr/bin/v2ctl
"
S="${WORKDIR}"

src_prepare() {
	sed -i 's|/usr/local/bin|/usr/bin|;s|/usr/local/etc|/etc|' systemd/system/*.service || die
	sed -i '/^User=/s/nobody/v2ray/;/^User=/aDynamicUser=true' systemd/system/*.service || die
	eapply_user
}

src_install() {
	dobin v2ray
	if use tool; then
		dobin v2ctl
	fi

	if ! use separate-geo; then
		insinto /usr/share/v2ray
		doins geosite.dat
		if use tiny-geoip; then
			newins geoip-only-cn-private.dat geoip.dat
		else
			doins geoip.dat
		fi
	fi

	insinto /etc/v2ray
	doins *.json
	doins "${FILESDIR}/example.client.v4.json"

	newinitd "${FILESDIR}/v2ray.v4.initd" v2ray
	systemd_newunit systemd/system/v2ray.service v2ray.service
	systemd_newunit systemd/system/v2ray@.service v2ray@.service
}
