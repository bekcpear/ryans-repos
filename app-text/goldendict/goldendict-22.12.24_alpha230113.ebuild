# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils xdg

GIT_HASH="e184162d"
MY_PV=${PV/_/-}
MY_PV=${MY_PV/alpha/alpha.}.$GIT_HASH

DESCRIPTION="Feature-rich dictionary lookup program"
HOMEPAGE="https://github.com/xiaoyifang/goldendict"
SRC_URI="https://github.com/xiaoyifang/goldendict/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ffmpeg"

RDEPEND="
	app-arch/bzip2
	>=app-text/hunspell-1.2:=
	dev-libs/eb
	dev-libs/lzo
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	media-libs/libvorbis
	media-libs/tiff:0
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXtst
	ffmpeg? (
		dev-qt/qtmultimedia:5
		media-libs/libao
		media-video/ffmpeg:0=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=(
	"$FILESDIR/$P-fix-equals-block.diff"
	"$FILESDIR/$P-fix-qtmultimedia-deps.diff"
)

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	# set commit hash
	sed -i -e "/git describe/aGIT_HASH=${GIT_HASH}" ${PN}.pro || die

	default
}

src_configure() {
	local myconf=()

	if ! use ffmpeg ; then
		myconf+=( CONFIG+=no_ffmpeg_player )
	fi

	myconf+=( CONFIG+=no_qtmultimedia_player )

	eqmake5 PREFIX="${EPREFIX}"/usr "${myconf[@]}" ${PN}.pro
}

src_install() {
	dobin ${PN}

	domenu redist/org.${PN}.GoldenDict.desktop
	doicon redist/icons/${PN}.png

	insinto /usr/share/${PN}/help
	doins help/gdhelp_en.qch
}
