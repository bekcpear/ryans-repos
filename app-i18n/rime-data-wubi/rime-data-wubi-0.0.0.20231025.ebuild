# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit optfeature

MY_PN="rime-wubi"
MY_COMMIT="152a0d3f3efe40cae216d1e3b338242446848d07"

DESCRIPTION="wubi input schema and dictionary for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-wubi"
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
		wubi86.dict.yaml \
		wubi86.schema.yaml \
		wubi_pinyin.schema.yaml \
		wubi_trad.schema.yaml

	einstalldocs
}

pkg_postinst() {
	optfeature "拼音反查、五筆拼音混合輸入" app-i18n/rime-data-pinyin-simp
}
