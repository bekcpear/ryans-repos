# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

MY_PN="fcitx5-rime"
DESCRIPTION="Chinese RIME input methods for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-rime"
SRC_URI="https://download.fcitx-im.org/fcitx5/fcitx5-rime/fcitx5-rime-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=app-i18n/fcitx-5.0.6:5
	app-i18n/librime
	app-i18n/rime-data
	sys-devel/gettext
"
RDEPEND="${DEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=("${FILESDIR}/${PN}-5.0.15-fix-conflicts-with-fcitx4-rime.diff")

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
