# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake

MY_PN="fcitx5-bamboo"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_PN}-${PV}"
DESCRIPTION="Typing Vietnamese by Bamboo core engine for Fcitx5"
HOMEPAGE="https://github.com/fcitx/fcitx5-bamboo"
SRC_URI="https://download.fcitx-im.org/fcitx5/${MY_PN}/${MY_P}.tar.xz -> ${P}.tar.xz"

LICENSE="LGPL-2.1+ MIT"
SLOT="5"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-i18n/fcitx:5
	sys-devel/gettext
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-lang/go-1.18
	kde-frameworks/extra-cmake-modules
"
pkg_postinst() {
	xdg_pkg_postinst
	[[ -n ${REPLACING_VERSIONS} ]] && return
	elog "After Fcitx5-bamboo is installed, it is recommend to use GUI app to config language for IME"
	elog "Run '# emerge -av app-i18n/fcitx-configtool' to modify typing language available"
	elog "See https://wiki.gentoo.org/wiki/Fcitx for more info"
}
