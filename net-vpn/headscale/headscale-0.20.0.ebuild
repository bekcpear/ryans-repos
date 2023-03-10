# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go systemd tmpfiles

DESCRIPTION="An open source, self-hosted implementation of the Tailscale control server"
HOMEPAGE="https://github.com/juanfont/headscale"
SRC_URI="https://github.com/juanfont/headscale/archive/refs/tags/v${PV//_/-}.tar.gz -> ${P}.tar.gz"

# https://github.com/bekcpear/vendor-for-go -> exec: .do/do.sh /path/to/repo headscale ${PV}
SRC_URI+=" https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P//_/-}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

BDEPEND=">=dev-lang/go-1.19:="
DEPEND=""
RDEPEND="
	acct-group/headscale
	acct-user/headscale
"

S="${WORKDIR}/${PN}-${PV//_/-}"

GO_LDFLAGS="-X github.com/juanfont/headscale/cmd/headscale/cli.Version=v${PV//_/-}"
GO_TARGET_PKGS="./cmd/headscale"

src_prepare() {
	rm -rf ./gen || die
	mv ../gopkg-vendors-vendor-${P//_/-}/gen ./ || die
	default
}

src_install() {
	go_src_install

	keepdir /etc/headscale

	dodoc config-example.yaml derp-example.yaml

	newtmpfiles "${FILESDIR}"/headscale.tmpfiles headscale.conf

	systemd_dounit "${FILESDIR}"/headscale.service
	systemd_install_serviced "${FILESDIR}"/headscale.service.conf headscale

	newconfd "${FILESDIR}"/headscale.confd headscale
	newinitd "${FILESDIR}"/headscale.initd headscale
}

pkg_postinst() {
	tmpfiles_process headscale.conf
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "headscale need a config file to run server, the default path: /etc/headscale/config.yaml"
		elog "Here is an example config file: ${EROOT}/usr/share/doc/${P}/config-example.yaml*"

		if ! systemd_is_booted; then
			elog "You can also set HEADSCALE_EXTRA_ARGS to '-c /path/to/config/file' in the"
			elog "  ${EROOT}/etc/conf.d/headscale file to specify a different path."
		else
			elog "You can also set 'ExecStart=' in the"
			elog "  ${EROOT}/etc/systemd/system/headscale.d/00gentoo.conf file"
			elog "  to specify customized command."
		fi

		elog
		elog "You have to add your user to the 'headscale' group to handle the headscale server,"
		if ! systemd_is_booted; then
			elog "  or set your customized user, group in the ${EROOT}/etc/conf.d/headscale file,"
		else
			elog "  or set your customized user, group in the"
			elog "  ${EROOT}/etc/systemd/system/headscale.d/00gentoo.conf file,"
		fi
		elog "  or run as root,"
		elog "  or use gRPC."
	else
		local major= minor=
		IFS="." read -r major minor _ <<<"$REPLACING_VERSIONS"
		if (( $major == 0 && $minor < 19 )); then
			IFS="." read -r major minor _ <<<"$PV"
			if (( $major > 0 )) || (( $major == 0 && $minor >= 19 )); then
				ewarn ">=headscale-0.19.0 has a DB structs breaking, please"
				ewarn "BACKUP your database before upgrading!!"
				ewarn "  see also:"
				ewarn "    1. https://github.com/juanfont/headscale/pull/1144"
				ewarn "    2. https://github.com/juanfont/headscale/pull/1171"
			fi
		fi
	fi
}
