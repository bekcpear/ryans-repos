# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go

DESCRIPTION="Run your GitHub Actions locally"
HOMEPAGE="https://github.com/nektos/act"
SRC_URI="https://github.com/nektos/act/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bekcpear/gopkg-vendors/archive/refs/tags/vendor-${P}.tar.gz -> ${P}-vendor.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

# due to command name conflict
DEPEND="!dev-go/act"
RDEPEND="
	${DEPEND}
	|| (
		app-containers/docker
		app-containers/podman
		)"
BDEPEND=">=dev-lang/go-1.18:="

GO_LDFLAGS="-X main.version=${PV}"
