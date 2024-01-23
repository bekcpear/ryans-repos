# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-middle-chinese"
MY_COMMIT="582e144e525525ac2b6c2498097d7c7919e84174"

DESCRIPTION="middle-chinese input schema and dictionary for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-middle-chinese"
SRC_URI="https://github.com/rime/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

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
		sampheng.schema.yaml \
		zyenpheng.dict.yaml \
		zyenpheng.schema.yaml

	einstalldocs
}
