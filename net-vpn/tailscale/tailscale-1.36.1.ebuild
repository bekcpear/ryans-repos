# Copyright 2020-2023 Gentoo Authors
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
VERSION_SHORT="1.36.1"
VERSION_LONG="1.36.1-t576b08e5e"
VERSION_GIT_HASH="576b08e5ee7cfd1ef052f44c4b2f72c62f965050"
GO_LDFLAGS="
	-X 'tailscale.com/version.Long=${VERSION_LONG}'
	-X 'tailscale.com/version.Short=${VERSION_SHORT}'
	-X 'tailscale.com/version.GitCommit=${VERSION_GIT_HASH}'"
GO_SBIN="tailscaled"
GO_TARGET_PKGS="
	./cmd/tailscale
	./cmd/tailscaled
"

src_configure() {
	use derp && GO_TARGET_PKGS+=" ./cmd/derper"
	use tools && GO_TARGET_PKGS+=" ./cmd/derpprobe"
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
