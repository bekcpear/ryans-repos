# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-combo-pinyin"
MY_COMMIT="17b66079a23a00d3214639fee2b8ae97d3e620dc"

DESCRIPTION="combo-pinyin input schema for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-combo-pinyin"
SRC_URI="https://github.com/rime/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="!app-i18n/rime-data:0"
RDEPEND="${DEPEND}"
PDEPEND="app-i18n/rime-data-luna-pinyin"

S="${WORKDIR}/${MY_PN}-${MY_COMMIT}"

RIME_DATA_DIR="/usr/share/rime-data"
DOCS=(
	AUTHORS
	LICENSE
	README.md
	layouts.md
)

src_install() {
	insinto "$RIME_DATA_DIR"
	doins \
		combo_pinyin.schema.yaml \
		combo_pinyin_10.schema.yaml \
		combo_pinyin_10_emacsen.schema.yaml \
		combo_pinyin_8.schema.yaml \
		combo_pinyin_8_emacsen.schema.yaml \
		combo_pinyin_9.schema.yaml \
		combo_pinyin_layouts.yaml

	einstalldocs
}
