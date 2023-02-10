# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go systemd

DESCRIPTION="Dendrite is a second-generation Matrix homeserver written in Go!"
HOMEPAGE="https://github.com/matrix-org/dendrite"

SRC_URI="https://github.com/matrix-org/dendrite/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD ISC LGPL-3 MIT MPL-2.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	>dev-lang/go-1.18.9999:=
	<=dev-lang/go-1.20.9999:=
"
# wait https://github.com/matrix-org/pinecone/pull/78 merge
BDEPEND+=" <dev-lang/go-1.20"

RDEPEND="
	acct-user/dendrite
	acct-group/dendrite
"
RESTRICT="strip"

src_install() {
	go_src_install

	insinto /etc/dendrite
	doins dendrite-sample.monolith.yaml
	doins dendrite-sample.polylith.yaml

	keepdir /var/log/dendrite
	fowners dendrite:dendrite /var/log/dendrite
	fperms 750 /var/log/dendrite

	dodoc -r docs/*

	newinitd "${FILESDIR}/dendrite-monolith.initd" dendrite-monolith
	newconfd "${FILESDIR}/dendrite-monolith.confd" dendrite-monolith
	systemd_dounit "${FILESDIR}"/dendrite-monolith.service
}
