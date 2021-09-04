# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Input method development support for xcb"
HOMEPAGE="https://github.com/fcitx/xcb-imdkit"
SRC_URI="https://github.com/fcitx/xcb-imdkit/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-1 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/xcb-util-keysyms
"
RDEPEND="${DEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules
"
