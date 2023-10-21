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

RDEPEND="
	|| (
		>=dev-java/openjdk-jre-bin-11
		>=virtual/jdk-11
	)
	acct-user/keycloak
	acct-group/keycloak
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
	doins conf/cache-ispn.xml conf/keycloak.conf "$FILESDIR"/quarkus.properties
	newins "$FILESDIR"/keycloak.runtime.env runtime.env
	fowners -R keycloak:keycloak /etc/keycloak
	fperms -R o-rwx /etc/keycloak

	keepdir /opt/keycloak-bin/conf
	dosym -r /etc/keycloak/quarkus.properties /opt/keycloak-bin/conf/quarkus.properties
	dosym -r /etc/keycloak/cache-ispn.xml /opt/keycloak-bin/conf/cache-ispn.xml
	dosym -r /etc/keycloak/keycloak.conf /opt/keycloak-bin/conf/keycloak.conf
	dosym -r /var/lib/keycloak/providers /opt/keycloak-bin/providers
	dosym -r /var/lib/keycloak/themes /opt/keycloak-bin/themes
	dosym -r /var/lib/keycloak/data /opt/keycloak-bin/data

	dodoc README.md LICENSE.txt

	newinitd "${FILESDIR}/keycloak.initd" keycloak
	newconfd "${FILESDIR}/keycloak.confd" keycloak

	systemd_dounit "${FILESDIR}/keycloak.service"
	systemd_install_serviced "${FILESDIR}"/keycloak.service.conf keycloak
}

pkg_preinst() {
	sed -Ei "s/@EROOT@/${EROOT//\//\\\/}/" "$ED"/usr/bin/kc.sh || die

	# set the newest available java_vm for user keycloak
	# prevent the system java_vm is set to 8 which causes keycloak a fatal error
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
		su -s /bin/sh -c "eselect java-vm set user $selected" - keycloak
	fi
	elog "JAVA VM for user: $(su -s /bin/sh -c 'whoami' - keycloak)"
	su -s /bin/sh -c 'eselect java-vm show' - keycloak

	# install the bash completion script
	# generate from keycloak to make sure it always satisfies the lastest version
	local bashcmpp0="${T}/bash-completion.sh"
	export JAVA_HOME=$(su -s /bin/sh -c "java -XshowSettings:properties -version 2>&1 | grep 'java.home'" - keycloak)
	JAVA_HOME=${JAVA_HOME#*=}
	JAVA_HOME=${JAVA_HOME## }
	"${ED}"/opt/keycloak-bin/bin/kc.sh tools completion >"$bashcmpp0" || die
	local cutLN=$(awk '/^Next time/ {print NR}' "$bashcmpp0")
	if [[ -n $cutLN ]]; then
		sed -Ei "${cutLN},\$d" "$bashcmpp0" || die
		cutLN=
	fi
	cutLN=$(awk '/^Changes detected/ {print NR}' "$bashcmpp0")
	if [[ -n $cutLN ]]; then
		sed -Ei "${cutLN}d" "$bashcmpp0" || die
	fi
	sed -Ei "/^$/d" "$bashcmpp0" || die
	sed -Ei '$s/kc.sh/realcomp/;$s/ kc[^[:space:]]*//g;$s/[[:space:]]+realcomp/ kc.sh/' \
		"$bashcmpp0" || die
	newbashcomp "$bashcmpp0" kc.sh
}

pkg_postinst() {
	echo
	elog "Please set/add proper build options in file '${EROOT}/etc/keycloak/keycloak.conf',"
	elog "  or 'KC_*' env vars (higher priority) in file '${EROOT}/etc/keycloak/runtime.env',"
	elog "  the details: https://www.keycloak.org/server/all-config?f=build"
	elog "  (a set of suggested vars: KC_DB, KC_FEATURES, KC_HEALTH_ENABLED)"
	elog "and than run:"
	elog "  # emerge --config '=${CATEGORY}/${P}'"
	elog "before starting the daemon."
	elog
	elog "If a build option is found at startup with an equal value to the value used"
	elog "when invoking the \`build\`, it gets silently ignored when using the \`--optimized\`"
	elog "flag (the default behavior of the service script). If it has a different value"
	elog "than the value used when a build was invoked, a warning is shown in the logs and"
	elog "the previously built value is used."
	elog "So, whenever pre-built build options change, you have to re-configure before starting."
	elog
	elog "Variables 'KEYCLOAK_ADMIN' and 'KEYCLOAK_ADMIN_PASSWORD' can be used to initial"
	elog "an admin account, just export them in CLI before the first start."
	echo
}

pkg_config() {
	export HOME=$(ls -1d ~keycloak) SHELL=/bin/bash USER=keycloak LOGNAME=keycloak
	local pre_exported_kc_vars
	pre_exported_kc_vars="$(export -p | grep -E '^declare -x KC_' | sed 's/^declare -x //')"
	echo
	elog "configuration prioritisation:"
	elog "  1. exported KC_* variables (in the file '${EROOT}/etc/keycloak/runtime.env')"
	# this may be a bug or special consideration in portage
	# refer to: https://bugs.gentoo.org/900465
	# `emerge` command uses the exported variables when install this package
	# but, `emerge --config` not, so, the pre-exported env variable cannot be
	# override from the portage's side.
	if [[ -n $pre_exported_kc_vars ]]; then
		ewarn "     - ATTENTION!!"
		ewarn "     - exists pre-exported KC_* env vars that exported when installing this pkg:"
		while read -r var; do
			ewarn "     -   $var"
		done <<<"$pre_exported_kc_vars"
		ewarn "     - (can be override by variables in the above runtime.env file)"
	fi
	elog "  2. build options listed in the '${EROOT}/etc/keycloak/keycloak.conf' file"
	echo
	chown -R keycloak:keycloak "$EROOT"/opt/keycloak-bin/lib
	su -p -c "'${EROOT}'/opt/keycloak-bin/bin/kc.sh build" keycloak
	su -p -c "'${EROOT}'/opt/keycloak-bin/bin/kc.sh show-config" keycloak
	echo
}
