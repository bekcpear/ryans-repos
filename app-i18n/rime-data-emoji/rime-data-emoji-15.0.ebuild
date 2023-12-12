# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-emoji"

DESCRIPTION="emoji input schema for RIME"
HOMEPAGE="https://rime.im/ https://github.com/rime/rime-emoji"
SRC_URI="https://github.com/rime/rime-emoji/archive/refs/tags/${PV}.tar.gz -> ${MY_PN}-${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="!app-i18n/rime-data:0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

RIME_DATA_DIR="/usr/share/rime-data"
DOCS=(
	AUTHORS
	LICENSE
	README.md
)

src_install() {
	insinto "$RIME_DATA_DIR"
	doins emoji_suggestion.yaml
	doins -r opencc

	einstalldocs
}
