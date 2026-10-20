# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go systemd tmpfiles

DESCRIPTION="An open source, self-hosted implementation of the Tailscale control server"
HOMEPAGE="https://github.com/juanfont/headscale"
SRC_URI="https://github.com/juanfont/headscale/archive/refs/tags/v${PV//_/-}.tar.gz -> ${P}.tar.gz"

# https://github.com/bekcpear/vendor-for-go -> exec: .do/do.sh /path/to/repo headscale ${PV}
SRC_URI+=" https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P//_/-}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

BDEPEND=">=dev-lang/go-1.26.8:="
DEPEND=""
RDEPEND="
	acct-group/headscale
	acct-user/headscale
"

S="${WORKDIR}/${PN}-${PV//_/-}"

# headscale reports its version from runtime/debug build info, which has no
# VCS metadata to read in a distfile build, and upstream offers no variable to
# inject one (its own Makefile passes '-X main.version=', a symbol that does not
# exist). The patch below adds two, so both the version and the real upstream
# commit can be stamped. UPDATE THE COMMIT ON EVERY BUMP, it is the object the
# v${PV} tag points at:
#   curl -s https://api.github.com/repos/juanfont/headscale/git/refs/tags/v${PV}
PATCHES=( "${FILESDIR}"/${P}-version-stamp.patch )

HEADSCALE_GIT_COMMIT="0f7d1e53"

GO_LDFLAGS="
	-X 'github.com/juanfont/headscale/hscontrol/types.stampVersion=v${PV//_/-}'
	-X 'github.com/juanfont/headscale/hscontrol/types.stampCommit=${HEADSCALE_GIT_COMMIT}'"
GO_TARGET_PKGS="./cmd/headscale"

src_prepare() {
	rm -rf ./gen || die
	mv ../gopkg-vendors-vendor-${P//_/-}/gen ./ || die
	default
}

src_install() {
	go_src_install

	# /var/lib/headscale is the home of acct-user/headscale, which creates it
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
		ewarn "**BACKUP** your database before restarting!"

		local major= minor=
		IFS="." read -r major minor _ <<<"$REPLACING_VERSIONS"
		if (( $major == 0 && $minor < 25 )); then
			ewarn ">=headscale-0.28.0 has dropped the database migration support for the"
			ewarn "databases created before 0.25.0, so upgrading directly from"
			ewarn "${REPLACING_VERSIONS} is NOT supported."
			ewarn "Upgrade sequentially through each stable release, taking the latest"
			ewarn "patch version of every minor release, and start with 0.25.1."
			ewarn "See the recommended update path:"
			ewarn "  https://headscale.net/stable/about/faq/#what-is-the-recommended-update-path-can-i-skip-multiple-versions-while-updating"
		fi
	fi
}
