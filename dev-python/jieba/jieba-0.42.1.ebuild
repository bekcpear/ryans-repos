# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Chinese Words Segmentation Utilities"
HOMEPAGE="
	https://pypi.org/project/jieba/
	https://github.com/fxsjy/jieba
"

SRC_URI="https://github.com/fxsjy/jieba/archive/refs/tags/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~arm64-macos"
RESTRICT="test"

BDEPEND="
	virtual/pkgconfig
"
