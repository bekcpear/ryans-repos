# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker desktop xdg-utils

DESCRIPTION="Tencent QQ Music for Linux."
HOMEPAGE="https://y.qq.com/download/download.html"
SRC_URI="https://dldir1.qq.com/music/clntupate/linux/deb/${P//-/_}_amd64.deb -> ${P}-amd64.deb"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
BDEPEND="${DEPEND}"
RDEPEND="
	x11-libs/gtk+
	x11-libs/libnotify
	dev-libs/nss
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-misc/xdg-utils
	app-accessibility/at-spi2-core
	sys-apps/util-linux
	dev-libs/libappindicator
	app-crypt/libsecret
"

S="${WORKDIR}"

src_prepare() {
	sed -i '/Name=QQmusic/aName[zh_CN]=QQ 音乐\nName[zh_HK]=QQ 音樂\nName[zh_TW]=QQ 音樂' usr/share/applications/qqmusic.desktop
	sed -i '/Comment=QQMusic/aComment[zh_CN]=QQ 音乐\nComment[zh_HK]=QQ 音樂\nComment[zh_TW]=QQ 音樂' usr/share/applications/qqmusic.desktop
	eapply_user
}

src_install() {
	insinto /opt
	doins -r opt/QQmusic
	fperms 0755 /opt/QQmusic/{chrome-sandbox,crashpad_handler,libEGL.so,libffmpeg.so,libGLESv2.so,libvk_swiftshader.so,qqmusic}
	dosym "${EROOT}/opt/QQmusic/qqmusic" /opt/bin/qqmusic
	domenu usr/share/applications/qqmusic.desktop
	doicon -s 16 usr/share/icons/hicolor/16x16/apps/qqmusic.png
	doicon -s 32 usr/share/icons/hicolor/32x32/apps/qqmusic.png
	doicon -s 64 usr/share/icons/hicolor/64x64/apps/qqmusic.png
	doicon -s 128 usr/share/icons/hicolor/128x128/apps/qqmusic.png
	doicon -s 256 usr/share/icons/hicolor/256x256/apps/qqmusic.png
	gzip -d usr/share/doc/qqmusic/changelog.gz
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
