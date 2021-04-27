# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/z3ntu/${PN}.git"

inherit git-r3 meson

DESCRIPTION="Libraries for razergenie."
HOMEPAGE="https://github.com/z3ntu/libopenrazer"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-apps/openrazer_test
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
