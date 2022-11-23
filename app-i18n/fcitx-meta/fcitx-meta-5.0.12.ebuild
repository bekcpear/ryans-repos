# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Merge this to pull in Fcitx packages"
HOMEPAGE="https://fcitx-im.org"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="bamboo +configtool +gtk2 +gtk3 +qt5 qt6 +rime"

# this is not the actual required use binding, but for this overlay
# due to QT6 support for Gentoo Linux is experimental and I haven't
# did enough tests for qt6-only building
REQUIRED_USE="qt6? ( qt5 )"

DEPEND=""
RDEPEND="
	app-i18n/fcitx:5
	bamboo? ( app-i18n/fcitx-bamboo:5 )
	configtool? ( app-i18n/fcitx-configtool:5 )
	gtk2? ( app-i18n/fcitx-gtk:5[gtk2] )
	gtk3? ( app-i18n/fcitx-gtk:5[gtk3] )
	qt5? ( app-i18n/fcitx-qt:5[qt6?] )
	rime? ( app-i18n/fcitx-rime:5 )
"
BDEPEND=""
