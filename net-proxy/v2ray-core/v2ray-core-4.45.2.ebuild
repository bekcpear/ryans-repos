# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="A platform for building proxies to bypass network restrictions."
HOMEPAGE="https://github.com/v2fly/v2ray-core"

SRC_URI="https://github.com/v2fly/v2ray-core/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="+tool"

BDEPEND="~dev-lang/go-1.19:="
DEPEND=""
RDEPEND="
	dev-libs/v2ray-geoip-bin
	|| (
		dev-libs/v2ray-domain-list-community-bin
		dev-libs/v2ray-domain-list-community
	)
"

PATCHES=(${FILESDIR}/${P}-quic.diff)

src_prepare() {
	sed -i 's|/usr/local/bin|/usr/bin|;s|/usr/local/etc|/etc|' release/config/systemd/system/*.service || die
	sed -i '/^User=/s/nobody/v2ray/;/^User=/aDynamicUser=true' release/config/systemd/system/*.service || die
	mv ../gopkg-vendors-vendor-${P}/* ./ || die
	eapply go-mod-sum.diff
	default
}

src_compile() {
	go build -mod vendor -v -work -o "bin/v2ray" -trimpath -ldflags "-s -w" ./main || die
	if use tool; then
		go build -mod vendor -v -work -o "bin/v2ctl" -trimpath -ldflags "-s -w" -tags confonly ./infra/control/main || die
	fi
}

src_install() {
	dobin bin/v2ray
	if use tool; then
		dobin bin/v2ctl
	fi

	insinto /etc/v2ray
	doins release/config/*.json
	doins "${FILESDIR}/example.client.json"

	newinitd "${FILESDIR}/v2ray.initd" v2ray
	systemd_newunit release/config/systemd/system/v2ray.service v2ray.service
	systemd_newunit release/config/systemd/system/v2ray@.service v2ray@.service
}
