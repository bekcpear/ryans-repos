# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="fcitx5-gtk"
DESCRIPTION="GTK IM module and glib based dbus client library for Fcitx"
HOMEPAGE="https://fcitx-im.org/ https://github.com/fcitx/fcitx5-gtk"
SRC_URI="https://download.fcitx-im.org/fcitx5/fcitx5-gtk/fcitx5-gtk-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="+gtk2 +gtk3 +introspection only-plugin +snooper"

DEPEND="
	>=dev-libs/glib-2.56
	dev-libs/libfmt
	gtk2? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	introspection? ( dev-libs/gobject-introspection )
	x11-libs/libxkbcommon
	x11-libs/libX11
"
RDEPEND="${DEPEND}"
BDEPEND="
	kde-frameworks/extra-cmake-modules
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	# Gentoo has not support GTK4 yet
	local mycmakeargs=(
		-DENABLE_GIR=$(usex introspection)
		-DENABLE_GTK2_IM_MODULE=$(usex gtk2)
		-DENABLE_GTK3_IM_MODULE=$(usex gtk3)
		-DENABLE_GTK4_IM_MODULE=no
		-DENABLE_SNOOPER=$(usex snooper)
		-DBUILD_ONLY_PLUGIN=$(usex only-plugin)
	)
	cmake_src_configure
}

update_input_method_module_cache() {
	if [[ ${1} == 2 ]]; then
		local binname="gtk-query-immodules-2.0"
		local libpath="gtk-2.0/2.10.0"
	elif [[ ${1} == 3 ]]; then
		local binname="gtk-query-immodules-3.0"
		local libpath="gtk-3.0/3.0.0"
	fi

	local updater=${EPREFIX}/usr/bin/${CHOST}-${binname}
	[[ -x ${updater} ]] || updater=${EPREFIX}/usr/bin/${binname}

	if [[ ! -x ${updater} ]]; then
		debug-print "${updater} is not executable"
		return
	fi

	ebegin "Updating ${libpath%\.0/*} input method module cache"
	GTK_IM_MODULE_FILE="${EROOT}/usr/$(get_libdir)/${libpath}/immodules.cache" \
		"${updater}" --update-cache
	eend $?
}

pkg_postinst() {
	use gtk2 && update_input_method_module_cache 2
	use gtk3 && update_input_method_module_cache 3
}

pkg_postrm() {
	use gtk2 && update_input_method_module_cache 2
	use gtk3 && update_input_method_module_cache 3
}
