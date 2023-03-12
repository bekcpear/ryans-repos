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

GO_SBIN="tailscaled"
GO_TARGET_PKGS="
	./cmd/tailscale
	./cmd/tailscaled
"

src_configure() {
	use derp && GO_TARGET_PKGS+=" ./cmd/derper"
	use tools && GO_TARGET_PKGS+=" ./cmd/derpprobe"

	. "$WORKDIR"/gopkg-vendors-vendor-$P/version.txt || die
	GO_LDFLAGS="
		-X 'tailscale.com/version.Long=${VERSION_LONG}'
		-X 'tailscale.com/version.Short=${VERSION_SHORT}'
		-X 'tailscale.com/version.GitCommit=${VERSION_GIT_HASH}'"
}

src_install() {
	go_src_install

	exeinto /usr/libexec
	doexe "$ED"/usr/bin/tailscale
	rm "$ED"/usr/bin/tailscale || die
	newbin "$FILESDIR"/tailscale.sh tailscale

	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}

	insinto /etc/default
	newins "${FILESDIR}"/tailscaled.defaults tailscaled

	newtmpfiles "${FILESDIR}"/${PN}.tmpfiles ${PN}.conf

	systemd_dounit "${FILESDIR}"/tailscaled.service
	systemd_newunit "${FILESDIR}"/tailscaled-at.service tailscaled@.service

	newinitd "${FILESDIR}"/${PN}d.initd ${PN}d

	if use derp; then
		insinto /etc/default
		newins "${FILESDIR}"/derper.defaults derper

		exeinto /usr/libexec
		doexe "${FILESDIR}"/derper-pre.sh

		systemd_dounit "${FILESDIR}"/derper.service
		systemd_install_serviced "${FILESDIR}"/derper.service.conf derper

		newinitd "${FILESDIR}"/derper.initd derper
	fi
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf

	# move the previous default state and log files to new default directory
	mkdir -p "${EROOT}"/var/lib/tailscale/tailscaled.d || die
	find "$EROOT"/var/lib/tailscale -maxdepth 1 \
		\( -name 'tailscaled.log*' -or -name 'tailscaled.state*' \
		-or -name 'derpmap.*' -or -name certs -or -name files \) \
		-exec mv '{}' "$EROOT"/var/lib/tailscale/tailscaled.d/ \; || die
}
