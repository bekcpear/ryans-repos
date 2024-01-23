# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-stroke"
MY_COMMIT="65fdbbf2f9485cc907cb9a6d6b9210938a50f71e"

DESCRIPTION="stroke input schema and dictionary for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-stroke"
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
	doins {stroke.dict,stroke.schema}.yaml

	einstalldocs
}
