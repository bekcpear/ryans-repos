# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-ipa"
MY_COMMIT="22b71710e029bcb412e9197192a638ab11bc2abf"

DESCRIPTION="ipa input schema and dictionary for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-ipa"
SRC_URI="https://github.com/rime/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_PN}-${PV}.tar.gz"

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
		ipa_xsampa.dict.yaml \
		ipa_xsampa.schema.yaml \
		ipa_yunlong.dict.yaml \
		ipa_yunlong.schema.yaml

	einstalldocs
}
