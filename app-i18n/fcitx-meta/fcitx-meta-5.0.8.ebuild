# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Merge this to pull in Fcitx packages"
HOMEPAGE="https://fcitx-im.org"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="+qt5 +gtk2 +gtk3 +configtool"

DEPEND=""
RDEPEND="
	app-i18n/fcitx:5
	qt5? ( app-i18n/fcitx-qt:5 )
	gtk2? ( app-i18n/fcitx-gtk:5[gtk2] )
	gtk3? ( app-i18n/fcitx-gtk:5[gtk3] )
	configtool? ( app-i18n/fcitx-configtool:5 )
"
BDEPEND=""
