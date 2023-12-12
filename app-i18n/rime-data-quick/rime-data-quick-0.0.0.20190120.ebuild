# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-quick"
MY_COMMIT="3fe5911ba608cb2df1b6301b76ad1573bd482a76"

DESCRIPTION="quick input schema and dictionary for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-quick"
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
	doins {quick5.dict,quick5.schema}.yaml

	einstalldocs
}
