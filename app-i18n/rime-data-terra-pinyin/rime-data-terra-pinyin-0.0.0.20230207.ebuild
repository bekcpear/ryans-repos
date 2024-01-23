# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-terra-pinyin"
MY_COMMIT="9427853de91d645d9aca9ceace8fe9e9d8bc5b50"

DESCRIPTION="terra-pinyin input schema and dictionary for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-terra-pinyin"
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
	doins {terra_pinyin.dict,terra_pinyin.schema}.yaml

	einstalldocs
}
