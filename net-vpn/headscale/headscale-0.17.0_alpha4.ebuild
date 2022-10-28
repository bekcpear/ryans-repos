# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go systemd

DESCRIPTION="An open source, self-hosted implementation of the Tailscale control server"
HOMEPAGE="https://github.com/juanfont/headscale"
SRC_URI="https://github.com/juanfont/headscale/archive/v${PV//_/-}.tar.gz -> ${P}.tar.gz
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P//_/-}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="BSD Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

BDEPEND=">=dev-lang/go-1.19:="
DEPEND="
	acct-group/headscale
	acct-user/headscale
"
RDEPEND="
	${DEPEND}
	net-firewall/iptables
"

S="${WORKDIR}/${PN}-${PV//_/-}"

PATCHES=(
	"${FILESDIR}"/config-socket.patch
)

GO_LDFLAGS="-X github.com/juanfont/headscale/cmd/headscale/cli.Version=v${PV//_/-}"

src_prepare() {
	rm -rf ./gen || die
	mv ../gopkg-vendors-vendor-${P//_/-}/gen ./ || die
	default
}

src_install() {
	go_src_install
	dodoc -r docs/* config-example.yaml
	keepdir /etc/headscale /var/lib/headscale
	systemd_dounit "${FILESDIR}"/headscale.service
	newconfd "${FILESDIR}"/headscale.confd headscale
	newinitd "${FILESDIR}"/headscale.initd headscale
	#fowners -R ${PN}:${PN} /etc/headscale /var/lib/headscale
}

pkg_postinst() {
	[[ -f "${EROOT}"/etc/headscale/config.yaml ]] && return
	elog "Please create ${EROOT}/etc/headscale/config.yaml before starting the service"
	elog "An example is in ${EROOT}/usr/share/doc/${P}/config-example.yaml"
}
