# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

MY_PN="fcitx5-configtool"
DESCRIPTION="GUI configuration tool for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-configtool"
SRC_URI="https://download.fcitx-im.org/fcitx5/fcitx5-configtool/fcitx5-configtool-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="+config-qt +kcm test"
RESTRICT="!test? ( test )"

DEPEND="
	>=app-i18n/fcitx-5.0.4:5
	>=app-i18n/fcitx-qt-5.0.2:5[-only-plugin]
	app-text/iso-codes
	config-qt? ( kde-frameworks/kitemviews:5 )
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtconcurrent:5
	kcm? (
		dev-qt/qtquickcontrols2:5
		kde-frameworks/kcoreaddons:5
		kde-frameworks/ki18n:5
		kde-frameworks/kiconthemes:5
		kde-frameworks/kpackage:5
		kde-frameworks/plasma:5
		kde-frameworks/kdeclarative:5
		>=kde-frameworks/kirigami-5.68:5
		x11-libs/libxkbcommon
	)
	kde-frameworks/kwidgetsaddons:5
	sys-devel/gettext
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-misc/xkeyboard-config
"
RDEPEND="${DEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=("${FILESDIR}/${PN}-5.0.9-match-icons-of-fcitx5-conflicts-fix.diff")

src_configure() {
	local mycmakeargs=(
		-DENABLE_CONFIG_QT=$(usex config-qt)
		-DENABLE_KCM=$(usex kcm)
		-DENABLE_TEST=$(usex test)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
