# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt-based SDK to develop applications for Matrix"
HOMEPAGE="https://github.com/quotient-im/libQuotient"
SRC_URI="https://github.com/quotient-im/libQuotient/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libQuotient-${PV}"

LICENSE="LGPL-2+"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="+e2ee"

DEPEND="
	dev-libs/qtkeychain:=[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5[ssl]
	e2ee? (
		dev-qt/qtsql:5
		>=dev-libs/openssl-1.1.0
		>=net-libs/libolm-3.2.5
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	# downstream patches
	"${FILESDIR}"/${P}-no-android.patch
	"${FILESDIR}"/${P}-no-tests.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_WITH_QT6=OFF
		-DBUILD_TESTING=OFF
		-DQuotient_ENABLE_E2EE=$(usex e2ee)
	)
	cmake_src_configure
}
