# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#TODO: systemd init script

DESCRIPTION="Collaboration suite, end-to-end encrypted and open-source."
HOMEPAGE="https://github.com/ether/etherpad-lite"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND=""
RDEPEND="${DEPEND}
	>=net-libs/nodejs-16.20.1
	acct-user/etherpad-lite
	acct-group/etherpad-lite"
BDEPEND=""

S="${WORKDIR}"

src_install () {
	newconfd "${FILESDIR}/etherpad-lite.confd" etherpad-lite
	newinitd "${FILESDIR}/etherpad-lite.initd" etherpad-lite
}
