# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="C command-line client for tldr pages"
HOMEPAGE="https://github.com/tldr-pages/tldr-c-client"
SRC_URI="https://github.com/tldr-pages/tldr-c-client/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# no test target
RESTRICT="test"

DEPEND="
	dev-libs/libzip
	net-misc/curl
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( CHANGELOG.md CONTRIBUTING.md LICENSE README.md )

S="${WORKDIR}/${PN}-client-${PV}/"

src_install() {
	dobin tldr

	einstalldocs

	doman "${S}"/man/tldr.1

	newbashcomp "${S}"/autocomplete/complete.bash tldr

	insinto /usr/share/zsh/site-functions
	newins "${S}"/autocomplete/complete.zsh _tldr
}
