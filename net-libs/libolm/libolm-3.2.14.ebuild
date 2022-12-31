# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Implementation of the olm and megolm cryptographic ratchets"
HOMEPAGE="https://gitlab.matrix.org/matrix-org/olm"
SRC_URI="https://gitlab.matrix.org/matrix-org/olm/-/archive/${PV}/olm-${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="static test"
RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/olm-${PV}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex static OFF ON)
		-DOLM_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	echo "subdirs(tests)" >"${BUILD_DIR}/CTestTestfile.cmake"
	cmake_src_test
}
