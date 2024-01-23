# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-bopomofo"
MY_COMMIT="c7618f4f5728e1634417e9d02ea50d82b71956ab"

DESCRIPTION="bopomofo input schema for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-bopomofo"
SRC_URI="https://github.com/rime/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="!app-i18n/rime-data:0"
RDEPEND="${DEPEND}"
PDEPEND="app-i18n/rime-data-terra-pinyin"

S="${WORKDIR}/${MY_PN}-${MY_COMMIT}"

RIME_DATA_DIR="/usr/share/rime-data"
DOCS=(
	AUTHORS
	LICENSE
	README.md
)

src_install() {
	insinto "$RIME_DATA_DIR"
	doins {bopomofo.schema,bopomofo_express.schema,bopomofo_tw.schema,zhuyin}.yaml

	einstalldocs
}
