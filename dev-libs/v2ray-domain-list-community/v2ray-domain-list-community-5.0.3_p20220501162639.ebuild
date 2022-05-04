# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Community managed domain list for V2Ray."
HOMEPAGE="https://github.com/v2fly/domain-list-community"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/v2fly/domain-list-community.git"
else
	EGO_SUM=(
		"github.com/golang/protobuf v1.5.0/go.mod"
		"github.com/golang/protobuf v1.5.2"
		"github.com/golang/protobuf v1.5.2/go.mod"
		"github.com/google/go-cmp v0.5.5/go.mod"
		"github.com/google/go-cmp v0.5.6"
		"github.com/v2fly/v2ray-core/v5 v5.0.3"
		"github.com/v2fly/v2ray-core/v5 v5.0.3/go.mod"
		"golang.org/x/sys v0.0.0-20211205182925-97ca703d548d"
		"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
		"golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1"
		"google.golang.org/protobuf v1.26.0-rc.1/go.mod"
		"google.golang.org/protobuf v1.26.0/go.mod"
		"google.golang.org/protobuf v1.28.0"
		"google.golang.org/protobuf v1.28.0/go.mod"
	)
	go-module_set_globals
	SRC_URI="https://github.com/v2fly/domain-list-community/archive/refs/tags/${PV#*_p}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
	S="${WORKDIR%/}/${PN#v2ray-}-${PV#*_p}"
fi

LICENSE="MIT"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	!dev-libs/v2ray-domain-list-community-bin
	!<net-proxy/v2ray-core-4.38.3
"
BDEPEND=">=dev-lang/go-1.18"

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		#TODO: Looking for a more elegant way to download deps
		export GOPROXY="https://goproxy.cn,direct" || die
		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_compile() {
	go run ./
}

src_install() {
	insinto /usr/share/v2ray
	newins dlc.dat geosite.dat
}

pkg_postinst() {
	:
}
