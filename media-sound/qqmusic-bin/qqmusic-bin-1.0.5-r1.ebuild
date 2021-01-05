# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker desktop xdg-utils

DESCRIPTION="Tencent QQ Music for Linux."
HOMEPAGE="https://y.qq.com/download/download.html"
SRC_URI="https://dldir1.qq.com/music/clntupate/linux/deb/${P/-bin-/_}_amd64.deb -> ${P}-amd64.deb"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="-* ~amd64"

DEPEND=""
BDEPEND="${DEPEND}"
RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	net-print/cups
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxcb
	x11-libs/pango
	x11-misc/xdg-utils
"

RESTRICT="strip"
S="${WORKDIR}"

pkg_pretend() {
	use amd64 || die "qqmusic-bin only works on amd64 for now"
}

src_prepare() {
	sed -i '/Name=QQmusic/aName[zh_CN]=QQ 音乐\nName[zh_HK]=QQ 音樂\nName[zh_TW]=QQ 音樂' usr/share/applications/qqmusic.desktop || die
	sed -i '/Comment=QQMusic/aComment[zh_CN]=QQ 音乐\nComment[zh_HK]=QQ 音樂\nComment[zh_TW]=QQ 音樂' usr/share/applications/qqmusic.desktop || die
	sed -i '/Name=QQmusic/s/Qmusic/Q Music/' usr/share/applications/qqmusic.desktop || die
	sed -i '/Comment=QQMusic/s/QMusic/Q Music/' usr/share/applications/qqmusic.desktop || die
	sed -i '/^Exec=/s/QQmusic/qqmusic-bin/' usr/share/applications/qqmusic.desktop || die
	gzip -d usr/share/doc/qqmusic/changelog.gz || die
	mv opt/QQmusic opt/qqmusic-bin || die
	eapply_user
}

src_install() {
	insinto /opt
	doins -r opt/qqmusic-bin
	fperms 0755 /opt/qqmusic-bin/{chrome-sandbox,crashpad_handler,libEGL.so,libffmpeg.so,libGLESv2.so,libvk_swiftshader.so,qqmusic}
	dosym "${EPREFIX%/}/opt/qqmusic-bin/qqmusic" /opt/bin/qqmusic-bin
	domenu usr/share/applications/qqmusic.desktop
	for si in 16 32 64 128 256; do
		doicon -s ${si} usr/share/icons/hicolor/${si}x${si}/apps/qqmusic.png
	done
	dodoc usr/share/doc/qqmusic/changelog
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
