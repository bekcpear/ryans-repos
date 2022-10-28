# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go

DESCRIPTION="Disk Usage/Free Utility - a better 'df' alternative"
HOMEPAGE="https://github.com/muesli/duf"

SRC_URI="https://github.com/muesli/duf/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${GO_SUM_LIST_SRC_URI}"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.15:="

GO_LDFLAGS="-X main.Version=v${PV}"

src_install() {
	go_src_install
	doman duf.1
}
