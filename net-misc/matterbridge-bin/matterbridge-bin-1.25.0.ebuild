# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="a simple chat bridge, IRC | Matrix | Mattermost | Telegram | XMPP | And more..."
HOMEPAGE="https://github.com/42wim/matterbridge"
SRC_URI="
	amd64? ( https://github.com/42wim/matterbridge/releases/download/v${PV}/${P/-bin-/-}-linux-64bit -> ${P}_amd64 )
	arm64? ( https://github.com/42wim/matterbridge/releases/download/v${PV}/${P/-bin-/-}-linux-arm64 -> ${P}_arm64 )
	https://raw.githubusercontent.com/42wim/matterbridge/v${PV}/matterbridge.toml.sample -> ${P}.toml.sample
	https://raw.githubusercontent.com/42wim/matterbridge/v${PV}/matterbridge.toml.simple -> ${P}.toml.simple
"

LICENSE="Apache-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"

RDEPEND="
	acct-user/matterbridge
	acct-group/matterbridge
"

QA_PREBUILT="/usr/bin/matterbridge"

S=${WORKDIR}

src_unpack() {
	local p
	if use amd64; then
		p=${P}_amd64
	elif use arm64; then
		p=${P}_arm64
	fi
	cp ${DISTDIR}/${p} ./${PN%-bin} || die
	cp ${DISTDIR}/${P}.toml.s{a,i}mple . || die
}

src_install() {
	dobin ${PN%-bin}

	insinto /etc/matterbridge
	newins ${P}.toml.sample matterbridge.toml.sample
	newins ${P}.toml.simple matterbridge.toml

	newconfd ${FILESDIR}/matterbridge.confd matterbridge
	newinitd ${FILESDIR}/matterbridge.initd matterbridge

	systemd_dounit ${FILESDIR}/matterbridge.service
}
