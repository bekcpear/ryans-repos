# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

MY_PN="linuxqq"
MY_PV=${PV/_beta/-b}
MY_PV=${MY_PV/_p/-}

DESCRIPTION="Tencent QQ."
HOMEPAGE="https://im.qq.com/linuxqq/index.html"
SRC_URI="https://down.qq.com/qqweb/LinuxQQ/${MY_PN}_${MY_PV}_amd64.deb -> ${P}_amd64.deb"

LICENSE="Tencent-QQ"
SLOT="0"
KEYWORDS="-* ~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/pango
"
BDEPEND=""

RESTRICT="mirror strip"
QA_PREBUILT="*"
QA_DESKTOP_FILE=
MY_HOME="/opt/linuxqq-bin"
S="${WORKDIR}"

src_prepare() {
	eapply_user
	sed -i "
		/Version=.*/d;
		s:/usr/local/bin/qq:${MY_HOME}/qq:;
		s:/usr/local/share/tencent-qq/qq.png:${MY_HOME}/qq.png:;
		s:Name=腾讯QQ:Name=Tencent QQ:;
		s:Comment=腾讯QQ:Comment=Tencent QQ:;
		s:Categories=.*:Categories=Network;InstantMessaging:;
		/GenericName.*/d;
		s:腾讯QQ:腾讯 QQ:;" usr/share/applications/qq.desktop || die
}

src_install() {
	insinto ${MY_HOME}
	doins usr/local/share/tencent-qq/*
	exeinto ${MY_HOME}
	doexe usr/local/bin/*
	domenu usr/share/applications/qq.desktop
	dosym -r "${MY_HOME}/qq" /opt/bin/qq
}
