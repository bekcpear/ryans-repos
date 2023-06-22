# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="fcitx5-qt"
DESCRIPTION="Qt library and IM module for fcitx5"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-qt"
SRC_URI="https://download.fcitx-im.org/fcitx5/fcitx5-qt/fcitx5-qt-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="BSD LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="only-plugin qt6 static-plugin"
REQUIRED_USE="static-plugin? ( only-plugin )"

DEPEND="
	!only-plugin? (
		>=app-i18n/fcitx-5.0.16:5
	)
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	qt6? (
		dev-qt/qtbase:6=[dbus(+),gui(+),widgets(+)]
	)
	x11-libs/libX11
	x11-libs/libxcb
	>=x11-libs/libxkbcommon-0.5.0
"
RDEPEND="${DEPEND}"
BDEPEND="
	!only-plugin? (
		sys-devel/gettext
	)
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	# gentoo has no official qt4 support, disable it
	local mycmakeargs=(
		-DENABLE_QT4=no
		-DENABLE_QT6=$(usex qt6)
		-DBUILD_ONLY_PLUGIN=$(usex only-plugin)
		-DBUILD_STATIC_PLUGIN=$(usex static-plugin)
	)
	cmake_src_configure
}
