# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go systemd tmpfiles

DESCRIPTION="Tailscale VPN client and CLI tools"
HOMEPAGE="https://tailscale.com https://github.com/tailscale/tailscale"

SRC_URI="https://github.com/tailscale/tailscale/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="derp +tailscale tools"
REQUIRED_USE="|| ( derp tailscale tools )"

BDEPEND=">=dev-lang/go-1.27.1:="

# 'iptables' is no longer mandatory,
# refer to https://github.com/tailscale/tailscale/issues/391 ,
#  and https://github.com/tailscale/tailscale/commit/243ce6ccc1a3e032e3d4a014e7dd09a9379c3c42
RDEPEND="
	derp? (
		acct-user/derper
		acct-group/derper
	)
"

GO_TARGET_PKGS=""

src_configure() {
	if use tailscale; then
		GO_TARGET_PKGS+=" ./cmd/tailscale ./cmd/tailscaled"
		GO_SBIN="tailscaled"
	fi
	use derp && GO_TARGET_PKGS+=" ./cmd/derper"
	use tools && GO_TARGET_PKGS+=" ./cmd/derpprobe"

	. "$WORKDIR"/gopkg-vendors-vendor-$P/version.txt || die
	GO_LDFLAGS="
		-X 'tailscale.com/version.longStamp=${VERSION_LONG}'
		-X 'tailscale.com/version.shortStamp=${VERSION_SHORT}'
		-X 'tailscale.com/version.gitCommitStamp=${VERSION_GIT_HASH}'"
}

src_install() {
	go_src_install

	if use tailscale; then
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

		# conf for fix, should be removed later
		exeinto /opt/bin
		newexe "${FILESDIR}"/fix-mis-configured-path.sh tailscaled.misconfiged.fix.sh
		sed -i '/ExecStartPre=/iExecStartPre=/opt/bin/tailscaled.misconfiged.fix.sh' \
			"${D}$(systemd_get_systemunitdir)"/tailscaled.service \
			"${D}$(systemd_get_systemunitdir)"/tailscaled@.service

		newinitd "${FILESDIR}"/${PN}d.initd ${PN}d
	fi

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

pkg_preinst() {
	if use tailscale; then
		sed -i "s#@EPREFIX@#$EPREFIX#" "$ED"/usr/bin/tailscale || die
		sed -i "s#@EPREFIX@#$EPREFIX#" "$ED"/opt/bin/tailscaled.misconfiged.fix.sh || die
	fi
}

pkg_postinst() {
	if use tailscale; then
		tmpfiles_process ${PN}.conf
		ewarn "multiple instances support still exists problems, such as iptables/nftables rules."
		ewarn "The iptables/nftables part can be opted out of by passing"
		ewarn "'--netfilter-mode=off', which makes tailscaled remove all of its own"
		ewarn "netfilter state instead of managing it. Be aware that:"
		ewarn "  1. it is an argument of the 'tailscale' CLI ('up' and 'set'), not of"
		ewarn "     'tailscaled', so it cannot be set via /etc/default/tailscaled"
		ewarn "  2. it is saved into the instance profile, so setting it once per"
		ewarn "     instance is enough and it survives daemon restarts and reboots"
		ewarn "  3. it takes effect on Linux only"
		ewarn "  4. routes and addresses are still installed whatever it is set to,"
		ewarn "     so it does NOT resolve the routing conflicts between instances"
		ewarn "  5. the firewall rules are then yours to write; in particular the"
		ewarn "     forwarding needed by exit nodes and subnet routers will not work"
		ewarn "     until you add it"
		ewarn "e.g.: tailscale --ins <instanceName> up --netfilter-mode=off"
	fi
}
