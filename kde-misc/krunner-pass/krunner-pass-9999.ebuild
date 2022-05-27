# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/bekcpear/${PN}.git"

inherit cmake git-r3 optfeature

DESCRIPTION="(Modified type instead version) Integrates krunner with pass"
HOMEPAGE="https://github.com/bekcpear/krunner-pass"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtwidgets:5
	kde-frameworks/kauth:5
	kde-frameworks/kcmutils:5
	kde-frameworks/kconfigwidgets:5
	kde-frameworks/ki18n:5
	kde-frameworks/knotifications:5
	kde-frameworks/krunner:5
	kde-frameworks/kservice:5
	kde-frameworks/ktextwidgets:5
"
RDEPEND="${DEPEND}
	app-admin/pass
	x11-misc/xdotool
"
BDEPEND="
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_EXPORT_COMPILE_COMMANDS=1
	)
	cmake_src_configure
}

pkg_postinst() {
	optfeature "TOTP support" app-admin/pass-otp
	elog
	elog "You should restart krunner to enable/refresh this feature."
	elog "  $ kquitapp5 krunner"
	elog "  $ kstart5 --windowclass krunner krunner"
	elog
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		ewarn "Consider to set the pinentry to a GUI version,"
		ewarn "otherwise, pass unlocking process may hanging."
		ewarn "Run:"
		ewarn "  # eselect pinentry list"
		ewarn "to list all available versions."
	fi

}
