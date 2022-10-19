# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Dendrite is a second-generation Matrix homeserver written in Go!"
HOMEPAGE="https://github.com/matrix-org/dendrite"

SRC_URI="https://github.com/matrix-org/dendrite/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD ISC LGPL-3 MIT MPL-2.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	>=dev-lang/go-1.18:=
"
RDEPEND="
	acct-user/dendrite
	acct-group/dendrite
"
RESTRICT="strip"

src_prepare() {
	mv ../gopkg-vendors-vendor-${P}/* ./ || die
	eapply go-mod-sum.diff
	default
}

src_compile() {
	CGO_ENABLED=1 go build -mod vendor -work -trimpath -ldflags "-s -w" -v -o "bin/" ./cmd/... || die
}

src_install() {
	dobin bin/*

	insinto /etc/dendrite
	doins dendrite-sample.monolith.yaml
	doins dendrite-sample.polylith.yaml

	keepdir /var/log/dendrite
	fowners dendrite:dendrite /var/log/dendrite
	fperms 750 /var/log/dendrite

	dodoc -r docs/*

	newinitd "${FILESDIR}/dendrite-monolith.initd" dendrite-monolith
	systemd_dounit "${FILESDIR}"/dendrite-monolith.service
}
