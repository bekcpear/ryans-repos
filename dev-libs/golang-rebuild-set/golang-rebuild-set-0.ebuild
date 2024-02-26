# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="@golang-rebuild set configuration"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~loong ~mips ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos ~x64-solaris"

RESTRICT="test"

S="$WORKDIR"

src_install() {
	# install the @golang-rebuild set for Portage
	# bug: https://bugs.gentoo.org/919751
	# pr: https://github.com/gentoo/portage/pull/1286
	insinto /usr/share/portage/config/sets
	newins "${FILESDIR}"/go-sets.conf go.conf
}
