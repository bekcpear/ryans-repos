# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-pinyin-simp"
MY_COMMIT="52b9c75f085479799553f2499c4f4c611d618cdf"

DESCRIPTION="pinyin-simp input schema and dictionary for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-pinyin-simp"
SRC_URI="https://github.com/rime/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="!app-i18n/rime-data:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${MY_COMMIT}"

RIME_DATA_DIR="/usr/share/rime-data"
DOCS=(
	AUTHORS
	LICENSE
	README.md
)

src_install() {
	insinto "$RIME_DATA_DIR"
	doins {pinyin_simp.dict,pinyin_simp.schema}.yaml

	einstalldocs
}
