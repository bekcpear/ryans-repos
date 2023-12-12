# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PN="rime-essay"
MY_COMMIT="e0519d0579722a0871efb68189272cba61a7350b"

DESCRIPTION="Data resources for Rime Input Method Engine"
HOMEPAGE="https://rime.im/ https://github.com/rime/plum"
SRC_URI="https://github.com/rime/${MY_PN}/archive/${MY_COMMIT}.tar.gz -> ${MY_PN}-${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="essay"
KEYWORDS="~amd64 ~x86"
IUSE="
	array
	+bopomofo
	+cangjie
	combo-pinyin
	double-pinyin
	emoji
	ipa
	+luna-pinyin
	middle-chinese
	pinyin-simp
	quick
	scj
	soutzoe
	stenotype
	+stroke
	+terra-pinyin
	wubi
	wugniu
"

DEPEND="!app-i18n/rime-data:0"
RDEPEND="${DEPEND}"
PDEPEND="
	app-i18n/rime-prelude
	array? ( app-i18n/rime-data-array )
	bopomofo? ( app-i18n/rime-data-bopomofo )
	cangjie? ( app-i18n/rime-data-cangjie )
	combo-pinyin? ( app-i18n/rime-data-combo-pinyin )
	double-pinyin? ( app-i18n/rime-data-double-pinyin )
	emoji? ( app-i18n/rime-data-emoji )
	ipa? ( app-i18n/rime-data-ipa )
	luna-pinyin? ( app-i18n/rime-data-luna-pinyin )
	middle-chinese? ( app-i18n/rime-data-middle-chinese )
	pinyin-simp? ( app-i18n/rime-data-pinyin-simp )
	quick? ( app-i18n/rime-data-quick )
	scj? ( app-i18n/rime-data-scj )
	soutzoe? ( app-i18n/rime-data-soutzoe )
	stenotype? ( app-i18n/rime-data-stenotype )
	stroke? ( app-i18n/rime-data-stroke )
	terra-pinyin? ( app-i18n/rime-data-terra-pinyin )
	wubi? ( app-i18n/rime-data-wubi )
	wugniu? ( app-i18n/rime-data-wugniu )
"

S="${WORKDIR}/${MY_PN}-${MY_COMMIT}"

RIME_DATA_DIR="/usr/share/rime-data"
DOCS=(
	AUTHORS
	LICENSE
	README.md
)

src_install() {
	insinto "$RIME_DATA_DIR"
	doins essay.txt

	einstalldocs
}
