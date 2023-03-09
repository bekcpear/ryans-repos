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
	fowners -R keycloak:keycloak /opt/keycloak-bin/lib

	local b
	for b in kc{,adm,reg}.sh; do
		fperms +x /opt/keycloak-bin/bin/$b
		if [[ $b != kc.sh ]]; then
			dosym -r /opt/keycloak-bin/bin/$b /usr/bin/$b
		else
			dobin "$FILESDIR"/kc.sh
		fi
	done

	insinto /var/lib/keycloak
	keepdir /var/lib/keycloak/data
	doins -r providers themes
	fowners -R keycloak:keycloak /var/lib/keycloak

	insinto /etc/keycloak
	doins conf/cache-ispn.xml conf/keycloak.conf
	newins "$FILESDIR"/keycloak.runtime.env runtime.env
	fowners -R keycloak:keycloak /etc/keycloak
	fperms -R o-rwx /etc/keycloak

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
	sed -Ei '$s/kc.sh/realcomp/;$s/ kc[^[:space:]]*//g;$s/[[:space:]]+realcomp/ kc.sh/' \
		bash-completion.sh || die
	newbashcomp bash-completion.sh kc.sh

	newinitd "${FILESDIR}/keycloak.initd" keycloak
	newconfd "${FILESDIR}/keycloak.confd" keycloak

	systemd_dounit "${FILESDIR}/keycloak.service"
	systemd_install_serviced "${FILESDIR}"/keycloak.service.conf keycloak
}

pkg_preinst() {
	sed -Ei "s/@EROOT@/${EROOT//\//\\\/}/" "$ED"/usr/bin/kc.sh || die
}

pkg_postinst() {
	echo
	elog "Please run \`emerge --config '=${CATEGORY}/${P}'\` before starting the daemon."
	elog "( you can export variables before executing to satisfy yourself, )"
	elog "( the list: https://www.keycloak.org/server/all-config?f=build   )"
	elog "( a set of suggested vars: KC_DB, KC_FEATURES, KC_HEALTH_ENABLED )"
	elog "If a build option is found at startup with an equal value to the value used"
	elog "when invoking the \`build\`, it gets silently ignored when using the \`--optimized\`"
	elog "flag (the default behavior of the service script). If it has a different value"
	elog "than the value used when a build was invoked, a warning is shown in the logs and"
	elog "the previously built value is used."
	elog "So, whenever pre-built build options change, you have to re-configure before starting."
	echo
}

pkg_config() {
	export HOME=$(ls -1d ~keycloak) SHELL=/bin/bash USER=keycloak LOGNAME=keycloak
	local exported_vars var
	eval "exported_vars=\$(su -p -c 'export -p | grep -E \"^declare -x KC_\" | sed \"s/^declare -x //\"' keycloak)"
	elog "exported KC_* variables:"
	if [[ -n $exported_vars ]]; then
		while read -r var; do
			elog "  $var"
		done <<<"$exported_vars"
		elog "( Note: )"
		elog "( the exported vars before emerging this packages will always be exported )"
		elog "( but you can override it/them )"
	else
		elog "  <NONE>"
	fi
	echo
	elog "configuration prioritisation:"
	elog "  1. exported KC_* variables"
	elog "  2. build options listed in the '${EROOT}/etc/keycloak/keycloak.conf' file"
	echo
	chown -R keycloak:keycloak "$EROOT"/opt/keycloak-bin/lib
	eval "su -p -c '\"${EROOT}\"/opt/keycloak-bin/bin/kc.sh build' keycloak"
	eval "su -p -c '\"${EROOT}\"/opt/keycloak-bin/bin/kc.sh show-config' keycloak"
	echo

	# set the newest available java_vm for user keycloak
	local jvm=0 selected=0 minver=11
	local -a available_jvm
	while read -r _ jvm _; do
		if (( ${jvm##*-} < $minver )); then
			continue
		fi
		if (( ${jvm##*-} > ${selected##*-} )); then
			selected=$jvm
		fi
	done <<<"$(eselect java-vm list | tail -n +2)"
	if [[ $selected == 0 ]]; then
		eerror "No available java_vm for keycloak-bin!"
	else
		eval "su -p -c 'eselect java-vm set user $selected' keycloak"
	fi
	elog "JAVA VM for user: keycloak"
	eval "su -p -c 'eselect java-vm show' keycloak"
}
