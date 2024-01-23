# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-wugniu"
MY_COMMIT="abd1ee98efbf170258fcf43875c21a4259e00b61"

DESCRIPTION="wugniu input schema and dictionary for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-wugniu"
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
		wugniu.schema.yaml \
		wugniu_lopha.dict.yaml \
		wugniu_lopha.schema.yaml

	einstalldocs
}
