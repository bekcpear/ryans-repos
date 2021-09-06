# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit chromium-2 desktop pax-utils unpacker xdg-utils

DESCRIPTION="Tencent QQ Music for Linux."
HOMEPAGE="https://y.qq.com/download/download.html"
SRC_URI="https://dldir1.qq.com/music/clntupate/linux/deb/${P/-bin-/_}_amd64.deb -> ${P}-amd64.deb"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	>=dev-libs/nss-3
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
QA_PREBUILT="*"
QA_DESKTOP_FILE=
QQMUSIC_HOME="/opt/qqmusic-bin"
S="${WORKDIR}"

pkg_pretend() {
	use amd64 || die "qqmusic-bin only works on amd64 for now"
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	eapply_user
	sed -i '/Name=qqmusic/aName[zh_CN]=QQ 音乐\nName[zh_HK]=QQ 音樂\nName[zh_TW]=QQ 音樂' \
		usr/share/applications/qqmusic.desktop || die
	sed -i '/Comment=Tencent\sQQMusic/aComment[zh_CN]=腾讯 QQ 音乐\nComment[zh_HK]=騰訊 QQ 音樂\nComment[zh_TW]=騰訊 QQ 音樂' \
		usr/share/applications/qqmusic.desktop || die
	sed -i '/Name=qqmusic/s/qqmusic/QQ Music/' usr/share/applications/qqmusic.desktop || die
	sed -i '/Comment=Tencent\sQQMusic/s/QMusic/Q Music/' usr/share/applications/qqmusic.desktop || die
	sed -i '/^Exec=/s/qqmusic/qqmusic-bin/' usr/share/applications/qqmusic.desktop || die
	gzip -d usr/share/doc/qqmusic/changelog.gz || die
}

src_install() {
	insinto ${QQMUSIC_HOME}
	doins -r opt/qqmusic/*
	dosym -r "${QQMUSIC_HOME}/qqmusic" /opt/bin/qqmusic-bin

	dodoc usr/share/doc/qqmusic/changelog
	domenu usr/share/applications/qqmusic.desktop
	local size
	for size in 16 32 64 128 256; do
		doicon -s ${size} usr/share/icons/hicolor/${size}x${size}/apps/qqmusic.png
	done

	fperms 0755 ${QQMUSIC_HOME}/{chrome-sandbox,crashpad_handler,qqmusic,libEGL.so,libGLESv2.so,libffmpeg.so,libvk_swiftshader.so}
	pax-mark m ${QQMUSIC_HOME}/qqmusic #https://pax.grsecurity.net/docs/mprotect.txt
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
