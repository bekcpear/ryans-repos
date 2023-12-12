# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-double-pinyin"
MY_COMMIT="69bf85d4dfe8bac139c36abbd68d530b8b6622ea"

DESCRIPTION="double-pinyin input schema for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-double-pinyin"
SRC_URI="https://github.com/rime/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_PN}-${PV}.tar.gz"

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
)

src_install() {
	insinto "$RIME_DATA_DIR"
	doins \
		double_pinyin.schema.yaml \
		double_pinyin_abc.schema.yaml \
		double_pinyin_flypy.schema.yaml \
		double_pinyin_mspy.schema.yaml \
		double_pinyin_pyjj.schema.yaml

	einstalldocs
}
