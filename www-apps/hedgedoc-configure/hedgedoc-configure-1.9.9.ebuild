# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#TODO: systemd init script

DESCRIPTION="HedgeDoc lets you create real-time collaborative markdown notes."
HOMEPAGE="https://github.com/hedgedoc/hedgedoc"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND=""
RDEPEND="${DEPEND}
	>=net-libs/nodejs-18.17.1[corepack]
	acct-user/hedgedoc
	acct-group/hedgedoc"
BDEPEND=""

S="${WORKDIR}"

src_install () {
	newconfd "${FILESDIR}/hedgedoc.confd" hedgedoc
	newinitd "${FILESDIR}/hedgedoc.initd" hedgedoc
}
