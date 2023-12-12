# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-array"
MY_COMMIT="b37aad383ff6e71e457aa6d1d47d2040af8649b9"

DESCRIPTION="array input schema and dictionary for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-array"
SRC_URI="https://github.com/rime/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
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
		array30.dict.yaml \
		array30.schema.yaml \
		array30_emoji.dict.yaml \
		array30_main.dict.yaml \
		array30_phrases.dict.yaml \
		array30_query.dict.yaml \
		array30_query.schema.yaml \
		array30_wsymbols.dict.yaml \
		array30_wsymbols.schema.yaml

	einstalldocs
}
