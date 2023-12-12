# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-soutzoe"
MY_COMMIT="beeaeca72d8e17dfd1e9af58680439e9012987dc"

DESCRIPTION="soutzoe input schema for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-soutzoe"
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
	doins {soutzoe.dict,soutzoe.schema}.yaml

	einstalldocs
}
