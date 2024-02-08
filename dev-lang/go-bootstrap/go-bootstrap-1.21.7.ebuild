# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bootstrap package for dev-lang/go"
HOMEPAGE="https://golang.org"
BOOTSTRAP_DIST="https://storage.googleapis.com/golang"
SRC_URI="
	amd64? ( ${BOOTSTRAP_DIST}/go${PV}.linux-amd64.tar.gz )
	arm64? ( ${BOOTSTRAP_DIST}/go${PV}.linux-arm64.tar.gz )
	loong? ( ${BOOTSTRAP_DIST}/go${PV}.linux-loong64.tar.gz )
	mips? (
		abi_mips_o32? (
			big-endian? ( ${BOOTSTRAP_DIST}/go${PV}.linux-mips.tar.gz )
			!big-endian? ( ${BOOTSTRAP_DIST}/go${PV}.linux-mipsle.tar.gz )
		)
		abi_mips_n64? (
			big-endian? ( ${BOOTSTRAP_DIST}/go${PV}.linux-mips64.tar.gz )
			!big-endian? ( ${BOOTSTRAP_DIST}/go${PV}.linux-mips64le.tar.gz )
		)
	)
	ppc64? (
		big-endian? ( ${BOOTSTRAP_DIST}/go${PV}.linux-ppc64.tar.gz )
		!big-endian? ( ${BOOTSTRAP_DIST}/go${PV}.linux-ppc64le.tar.gz )
	)
	riscv? ( ${BOOTSTRAP_DIST}/go${PV}.linux-riscv64.tar.gz )
	s390? ( ${BOOTSTRAP_DIST}/go${PV}.linux-s390x.tar.gz )
	x86? ( ${BOOTSTRAP_DIST}/go${PV}.linux-386.tar.gz )
	x64-macos? ( ${BOOTSTRAP_DIST}/go${PV}.darwin-amd64.tar.gz )
	arm64-macos? ( ${BOOTSTRAP_DIST}/go${PV}.darwin-arm64.tar.gz )
	x64-solaris? ( ${BOOTSTRAP_DIST}/go${PV}.solaris-amd64.tar.gz )
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64 ~loong ~mips ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="abi_mips_n64 abi_mips_o32 big-endian"
RESTRICT="strip"
QA_PREBUILT="*"

S="${WORKDIR}"

src_install() {
	dodir /usr/lib
	mv go "${ED}/usr/lib/go-bootstrap" || die
}
