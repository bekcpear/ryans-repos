# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-luna-pinyin"
MY_COMMIT="79aeae200a7370720be98232844c0715f277e1c0"

DESCRIPTION="luna-pinyin input schema and dictionary for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-luna-pinyin"
SRC_URI="https://github.com/rime/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
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
	doins \
		luna_pinyin.dict.yaml \
		luna_pinyin.schema.yaml \
		luna_pinyin_fluency.schema.yaml \
		luna_pinyin_simp.schema.yaml \
		luna_pinyin_tw.schema.yaml \
		luna_quanpin.schema.yaml \
		pinyin.yaml

	einstalldocs
}
