# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/z3ntu/${PN}.git"

inherit git-r3 meson

DESCRIPTION="Razer devices configurator"
HOMEPAGE="https://github.com/z3ntu/RazerGenie"

LICENSE="GPL-3"
SLOT="0"
IUSE="matrix"

DEPEND="
	dev-libs/libopenrazer
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	sys-apps/openrazer
	x11-themes/hicolor-icon-theme
"
BDEPEND="
	dev-qt/linguist-tools:5
	sys-apps/openrazer_test
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		"$(meson_use matrix include_matrix_discovery)"
	)
	meson_src_configure
}
