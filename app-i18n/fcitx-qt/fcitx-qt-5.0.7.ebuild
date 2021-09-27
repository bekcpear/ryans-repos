# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="fcitx5-qt"
DESCRIPTION="Qt library and IM module for fcitx5"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-qt"
SRC_URI="https://github.com/fcitx/fcitx5-qt/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="only-plugin static-plugin"
REQUIRED_USE="static-plugin? ( only-plugin )"

DEPEND="
	app-i18n/fcitx:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libxkbcommon
"
RDEPEND="${DEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	# gentoo only support qt5 officially, disable qt4 & qt6 for now
	local mycmakeargs=(
		-DENABLE_QT4=no
		-DENABLE_QT6=no
		-DBUILD_ONLY_PLUGIN=$(usex only-plugin)
		-DBUILD_STATIC_PLUGIN=$(usex static-plugin)
	)
	cmake_src_configure
}
