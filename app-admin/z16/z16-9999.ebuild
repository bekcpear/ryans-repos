# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="A bash script project that aims to maintain dotfiles."
HOMEPAGE="https://github.com/bekcpear/z16"
EGIT_REPO_URI="https://github.com/bekcpear/z16.git"

SLOT="0"
LICENSE="GPL-2"
IUSE=

RDEPEND="
	sys-apps/grep
	sys-apps/util-linux
"

Z16INSTDIR="/var/lib/z16"
GLOBALCONF=".z16.g.conf"
src_prepare() {
	sed -i "s#INSTDIR\s=#INSTDIR = ${Z16INSTDIR}#" config/z16rc.example
	sed -i "s#INSTGLOBALCONFNAME\s=.*#INSTGLOBALCONFNAME = ${GLOBALCONF}#" config/z16rc.example
	eapply_user
}

src_install() {
	insinto /usr/share/z16
	doins {helperFuncs,init,mainFuncs,parseFuncs,z16}.sh
	insinto /etc/z16
	newins config/z16rc.example z16rc
	newins config/global-config-file.example default_configurations

	dosym "${EPREFIX%/}/etc/z16/default_configurations" "${Z16INSTDIR}/${GLOBALCONF}"
	dosym "${EPREFIX%/}/usr/share/z16/z16.sh" /usr/bin/z16
	fperms +x /usr/share/z16/z16.sh
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog "You can edit the configuration file"
		elog "    /etc/z16/z16rc"
		elog "to configure the directory which storing instances and"
		elog "the global configuration filename of all instances."
		elog ""
		elog "The default path of the global configuration file of all instances is:"
		elog "    ${Z16INSTDIR}/${GLOBALCONF}"
	fi
}
