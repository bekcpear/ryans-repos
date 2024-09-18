# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="https://syncthing.net"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${PN}-source-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~arm64-macos"

BDEPEND=">=dev-lang/go-1.21.0"

DOCS=( README.md AUTHORS CONTRIBUTING.md )

S="${WORKDIR}"/${PN}

src_compile() {
	GOARCH= go run build.go -version "v${PV}" \
		-no-upgrade \
		-build-out="${T}"/go-bin/ \
		${GOARCH:+-goarch="${GOARCH}"} \
		build syncthing || die "build failed"
}

src_test() {
	go run build.go test || die "test failed"
}

src_install() {
	go_src_install

	doman man/syncthing*.[157]
	einstalldocs
}
