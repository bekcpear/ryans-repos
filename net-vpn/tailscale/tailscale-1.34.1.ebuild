# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go systemd tmpfiles

DESCRIPTION="Tailscale VPN client and CLI tools"
HOMEPAGE="https://tailscale.com https://github.com/tailscale/tailscale"

SRC_URI="https://github.com/tailscale/tailscale/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="derp tools"

BDEPEND=">=dev-lang/go-1.19:="
RDEPEND="
	net-firewall/iptables
	derp? (
		acct-user/derper
		acct-group/derper
	)
"

# These settings are obtained by running ./build_dist.sh shellvars` in the upstream repo.
VERSION_SHORT="1.34.1"
VERSION_LONG="1.34.1-t331d553a5"
VERSION_GIT_HASH="331d553a5eb90401c071021bae5dd24ce3993500"
GO_LDFLAGS="
	-X 'tailscale.com/version.Long=${VERSION_LONG}'
	-X 'tailscale.com/version.Short=${VERSION_SHORT}'
	-X 'tailscale.com/version.GitCommit=${VERSION_GIT_HASH}'"
GO_SBIN="tailscaled"

src_compile() {
	if use derp; then
		go_build ./cmd/derper
	fi
	if use tools; then
		go_build ./cmd/derpprobe
	fi
	go_build ./cmd/tailscale ./cmd/tailscaled
}

src_install() {
	go_src_install

	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}

	insinto /etc/default
	newins "${FILESDIR}"/tailscaled.defaults tailscaled

	newtmpfiles "${FILESDIR}"/${PN}.tmpfiles ${PN}.conf

	systemd_dounit cmd/tailscaled/tailscaled.service

	newinitd "${FILESDIR}"/${PN}d.initd ${PN}d

	if use derp; then
		insinto /etc/default
		newins "${FILESDIR}"/derper.defaults derper

		exeinto /usr/libexec
		doexe "${FILESDIR}"/derper-pre.sh

		systemd_dounit "${FILESDIR}"/derper.service

		newinitd "${FILESDIR}"/derper.initd derper
	fi
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
