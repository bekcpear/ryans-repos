# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 systemd

DESCRIPTION="Open Source Identity and Access Management"
HOMEPAGE="https://github.com/keycloak/keycloak"
SRC_URI="https://github.com/keycloak/keycloak/releases/download/${PV}/keycloak-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	|| (
		>=dev-java/openjdk-jre-bin-11
		>=virtual/jdk-11
	)
"
RDEPEND="
	acct-user/keycloak
	acct-group/keycloak
	$BDEPEND
"

S="${WORKDIR}/keycloak-$PV"

src_install() {
	insinto /opt/keycloak-bin
	doins -r bin lib

	local b
	for b in kc{,adm,reg}.sh; do
		fperms +x /opt/keycloak-bin/bin/$b
		dosym -r /opt/keycloak-bin/bin/$b /usr/bin/$b
	done

	insinto /var/lib/keycloak
	keepdir /var/lib/keycloak/data
	doins -r providers themes
	fowners -R keycloak:keycloak /var/lib/keycloak

	insinto /etc/keycloak
	doins conf/cache-ispn.xml conf/keycloak.conf
	fowners -R keycloak:keycloak /etc/keycloak

	keepdir /opt/keycloak-bin/conf
	dosym -r /etc/keycloak/cache-ispn.xml /opt/keycloak-bin/conf/cache-ispn.xml
	dosym -r /etc/keycloak/keycloak.conf /opt/keycloak-bin/conf/keycloak.conf
	dosym -r /var/lib/keycloak/providers /opt/keycloak-bin/providers
	dosym -r /var/lib/keycloak/themes /opt/keycloak-bin/themes
	dosym -r /var/lib/keycloak/data /opt/keycloak-bin/data

	dodoc README.md LICENSE.txt

	./bin/kc.sh tools completion >bash-completion.sh || die
	local cutLN=$(awk '/^Next time/ {print NR}' bash-completion.sh)
	if [[ -n $cutLN ]]; then
		sed -Ei "${cutLN},\$d" bash-completion.sh || die
		cutLN=
	fi
	cutLN=$(awk '/^Changes detected/ {print NR}' bash-completion.sh)
	if [[ -n $cutLN ]]; then
		sed -Ei "${cutLN}d" bash-completion.sh || die
	fi
	sed -Ei "/^$/d" bash-completion.sh || die
	sed -Ei '$s/kc.sh/realcomp/;$s/kc[^[:space:]]*//g;$s/[[:space:]]+realcomp/ kc.sh/' \
		bash-completion.sh || die
	newbashcomp bash-completion.sh kc.sh

	newinitd "${FILESDIR}/keycloak.initd" keycloak
	newconfd "${FILESDIR}/keycloak.confd" keycloak

	systemd_dounit "${FILESDIR}/keycloak.service"
	systemd_install_serviced "${FILESDIR}"/keycloak.service.conf keycloak
}
