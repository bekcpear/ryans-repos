# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go systemd

DESCRIPTION="A server that allows to get/push customized notifications"
HOMEPAGE="https://github.com/Finb/bark-server"

SRC_URI="https://github.com/Finb/bark-server/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="
	>=dev-lang/go-1.17:=
"
DEPEND=""
RDEPEND="
	acct-user/bark-server
	acct-group/bark-server
"

COMMIT_ID="a4e07446e1d3e336d7366ce2f20aa8daf5c134f2" # git checkout v${PV} && git rev-parse HEAD
GO_LDFLAGS="-X 'main.version=${PV}' -X 'main.buildDate=@@BUILD_DATE@@' -X 'main.commitID=${COMMIT_ID}'"
GO_LDFLAGS_EXMAP[BUILD_DATE]="date '+%F %T%z'"

sed_eroot() {
	local dst="${T}/$(basename ${1})"
	cp -L "${1}" "${dst}" || die
	sed -Ei "s/@@EROOT@@/${EROOT//\//\\\/}\//" "${dst}" || die
}

src_install() {
	exeinto /usr/libexec
	doexe "${T}/go-bin/bark-server"

	sed_eroot "${FILESDIR}/bark-server"
	dobin "${T}/bark-server"

	insinto /etc/bark-server
	sed_eroot "${FILESDIR}/bark-server.env"
	doins "${T}/bark-server.env"

	dodoc -r docs/*

	sed_eroot "${FILESDIR}/bark-server.initd"
	sed_eroot "${FILESDIR}/bark-server.confd"
	newinitd "${T}/bark-server.initd" bark-server
	newconfd "${T}/bark-server.confd" bark-server

	sed_eroot "${FILESDIR}/bark-server.service"
	systemd_dounit "${T}/bark-server.service"
}
