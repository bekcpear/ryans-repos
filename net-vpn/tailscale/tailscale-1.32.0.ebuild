# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd tmpfiles

# These settings are obtained by running ./build_dist.sh shellvars` in
# the upstream repo.
VERSION_MINOR="1.32"
VERSION_SHORT="1.32.0"
VERSION_LONG="1.32.0-tfc688fe02"
VERSION_GIT_HASH="fc688fe02496cacf919f9fed2069ea41a8b87500"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"

SRC_URI="https://github.com/tailscale/tailscale/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="derp"

BDEPEND=">=dev-lang/go-1.19:="
RDEPEND="net-firewall/iptables"

# This translates the build command from upstream's build_dist.sh to an
# ebuild equivalent.
build_dist() {
	ego build -mod vendor -tags xversion -ldflags "
		-X tailscale.com/version.Long=${VERSION_LONG}
		-X tailscale.com/version.Short=${VERSION_SHORT}
		-X tailscale.com/version.GitCommit=${VERSION_GIT_HASH}" "$@"
}

src_prepare() {
	mv ../gopkg-vendors-vendor-${P}/* ./ || die
	eapply go-mod-sum.diff
	eapply_user
}

src_compile() {
	if use derp; then
		build_dist ./cmd/derper
	fi
	build_dist ./cmd/tailscale
	build_dist ./cmd/tailscaled
}

src_install() {
	if use derp; then
		dosbin derper
	fi

	dosbin tailscaled
	dobin tailscale

	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}
	keepdir /var/log/${PN}
	fperms 0750 /var/log/${PN}

	insinto /etc/default
	newins "${FILESDIR}"/tailscaled.defaults tailscaled

	systemd_dounit cmd/tailscaled/tailscaled.service
	newtmpfiles "${FILESDIR}"/${PN}.tmpfiles ${PN}.conf

	newinitd "${FILESDIR}"/${PN}d.initd ${PN}d

	if use derp; then
		keepdir /var/lib/derper
		fperms 0750 /var/lib/derper

		insinto /etc/default
		newins "${FILESDIR}"/derper.defaults derper

		systemd_dounit "${FILESDIR}"/derper.service

		newinitd "${FILESDIR}"/derper.initd derper
	fi
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}
