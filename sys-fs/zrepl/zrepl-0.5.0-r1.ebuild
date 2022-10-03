# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="One-stop ZFS backup & replication solution."
HOMEPAGE="https://github.com/zrepl/zrepl https://zrepl.github.io/"

SRC_URI="https://github.com/zrepl/zrepl/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD ISC LGPL-3 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	>=dev-lang/go-1.12:=
"
DEPEND=""
RDEPEND=""

PATCHES=("${FILESDIR}/${PN}-0.5.0-patch-systemd.service.diff")

src_prepare() {
	mv ../gopkg-vendors-vendor-${P}/* ./ || die
	eapply go-mod-sum.diff
	default
}

src_compile() {
	export CGO_ENABLED=0
	go build -mod vendor -v -work -o "bin/zrepl" -trimpath \
		-ldflags "-s -w -X github.com/zrepl/zrepl/version.zreplVersion=${PV}" . || die
	bin/zrepl gencompletion bash dist/zrepl.bash || die
	bin/zrepl gencompletion zsh dist/zrepl.zsh || die
}

src_install() {
	dobin bin/zrepl

	keepdir /etc/zrepl
	keepdir /var/log/zrepl

	insinto /usr/share/zrepl
	doins -r config/samples

	insinto /usr/share/zsh/site-functions/
	newins dist/zrepl.zsh _zrepl
	insinto /usr/share/bash-completion/completions/
	newins dist/zrepl.bash zrepl

	newinitd "${FILESDIR}/zrepl.initd" zrepl
	systemd_dounit dist/systemd/zrepl.service
}
