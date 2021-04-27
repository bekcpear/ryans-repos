# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="razer_test"
EGIT_REPO_URI="https://github.com/z3ntu/${MY_PN}.git"

inherit git-r3 meson

DESCRIPTION="A work-in-progress replacement for OpenRazer."
HOMEPAGE="https://github.com/z3ntu/razer_test"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
