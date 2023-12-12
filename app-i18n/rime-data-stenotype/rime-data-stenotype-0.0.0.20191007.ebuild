# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-stenotype"
MY_COMMIT="f3e9189d5ce33c55d3936cc58e39d0c88b3f0c88"

DESCRIPTION="stenotype input schema for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-stenotype"
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
	doins stenotype.schema.yaml

	einstalldocs
}
