# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go systemd

DESCRIPTION="Keybase command-line utility, and local service"
HOMEPAGE="https://keybase.io/ https://github.com/keybase/client"
SRC_URI="https://github.com/keybase/client/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.19:="

S="${WORKDIR}/client-${PV}/go"
GO_TAGS="production"
GO_TARGET_PKGS="./keybase"

src_install() {
	go_src_install

	systemd_douserunit ../packaging/linux/systemd/keybase.service

	newbashcomp "${FILESDIR}"/bash-completion.sh keybase

	insinto /usr/share/zsh/site-functions
	newins "${FILESDIR}"/zsh-completion.zsh _keybase

	# GUI maybe be added in the future
}
