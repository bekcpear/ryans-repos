# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODULES_OPTIONAL_USE="modules"
MODULES_OPTIONAL_USE_IUSE_DEFAULT="1"
inherit linux-mod

ORAZER_P="openrazer-${PV}"
DESCRIPTION="A collection of kernel drivers for Razer devices."
HOMEPAGE="https://github.com/openrazer/openrazer"
SRC_URI="https://github.com/openrazer/openrazer/archive/refs/tags/v${PV}.tar.gz -> ${ORAZER_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="dkms"
REQUIRED_USE="|| ( modules dkms )"

S="${WORKDIR%/}/${ORAZER_P}/driver"
MODULE_NAMES="
	razerkbd(kernel/drivers/hid)
	razermouse(kernel/drivers/hid)
	razerkraken(kernel/drivers/hid)
	razeraccessory(kernel/drivers/hid)
"
BUILD_TARGETS="clean modules"

src_compile() {
	BUILD_PARAMS="-C ${KV_DIR} M=${S}"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
	if use dkms; then
		pushd ..
		export DESTDIR=${ED}
		emake setup_dkms
		popd
	fi
}

pkg_postinst() {
	linux-mod_pkg_postinst
	if use modules; then
		if [[ $(uname -r) != "${KV_FULL}" ]]; then
			ewarn "You have just built ${PN} for kernel ${KV_FULL}, yet the currently"
			ewarn "running kernel is $(uname -r). If you intend to use these openrazer modules"
			ewarn "on the currently running machine, you will first need to reboot it into the"
			ewarn "kernel ${KV_FULL}, for which these modules was built."
		else
			local i old
			local -a loaded_modules
			local -a my_modules=( $(while read l; do echo ${l%(*}; done <<< "${MODULE_NAMES}") )
			for (( i = 0; i < ${#my_modules[@]}; ++i )); do
				if [[ -f /sys/module/${my_modules[i]}/version ]]; then
					old="$(< /sys/module/${my_modules[i]}/version)"
					loaded_modules+=( "${my_modules[i]}" )
				fi
			done
			if [[ ${old} != '' && ${old} != ${PV} ]]; then
				ewarn
				ewarn "You appear to have just upgraded ${PN} from version v$old to v$PV."
				ewarn "However, the old version is still running on your system. In order to use the"
				ewarn "new version, you will need to remove the old loaded modules (${loaded_modules[@]})"
				ewarn "and load the new ones."
				ewarn "You can accomplish this with the following commands as root user:"
				ewarn
				ewarn " # modprobe -r ${loaded_modules[@]}"
				ewarn " and then pull out and replug corresponding devices. Or, just restart your computer."
				ewarn
				ewarn "If you want to reload modules without replug devices, refer to /lib/udev/razer_mount"
				ewarn
			fi
		fi
		elog
		elog "Everytime when you upgrade/downgrade the kernel, these modules should be rebuilt via:"
		elog " # emerge @module-rebuild"
		elog "to satisfy the current used kernel."
		if use dkms; then
			elog " OR"
			elog "Use DKMS tools like sys-kernel/dkms::guru to manage these modules dynamically."
		fi
		elog
	elif use dkms; then
		local inststate="(NOT INSTALLED)"
		has_version sys-kernel/dkms && inststate="(INSTALLED)"
		ewarn
		ewarn "You should build these modules by yourself via DKMS tools like sys-kernel/dkms ${inststate}."
		ewarn " e.g.: # dkms add ${PN}/${PV}"
		ewarn "       # dkms install ${PN}/${PV}"
		ewarn
	fi
}
