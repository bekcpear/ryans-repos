# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}

MY_PV=${PV/_/}

inherit toolchain-funcs

DESCRIPTION="A concurrent garbage collected and typesafe programming language"
HOMEPAGE="https://go.dev"

SRC_URI="https://storage.googleapis.com/golang/go${MY_PV}.src.tar.gz "
S="${WORKDIR}"/go
KEYWORDS="-* ~amd64 ~arm ~arm64 ~loong ~mips ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"

[[ $PV =~ ^([[:digit:]]+)\.([[:digit:]]+)(\.([[:digit:]]+))?(_.*)?$ ]] || true
PV_MINOR="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
PV_PATCH="${BASH_REMATCH[4]}"
GOROOT_VALUE="/usr/lib/go${PV_MINOR}"

LICENSE="BSD"
SLOT="${PV_MINOR}/${PV_PATCH:-0}"
IUSE="abi_mips_o32 abi_mips_n64 cpu_flags_x86_sse2"

BDEPEND="
	|| (
		dev-lang/go
		dev-lang/go-bootstrap
	)
"
RDEPEND="app-eselect/eselect-go"

# the *.syso files have writable/executable stacks
QA_EXECSTACK='*.syso'

# Do not complain about CFLAGS, etc, since Go doesn't use them.
QA_FLAGS_IGNORED='.*'

# The tools in /usr/lib/go.* should not cause the multilib-strict check to fail.
QA_MULTILIB_PATHS="usr/lib/go.*/pkg/tool/.*/.*"

# This package triggers "unrecognized elf file(s)" notices on riscv.
# https://bugs.gentoo.org/794046
QA_PREBUILT='.*'

# Do not strip this package. Stripping is unsupported upstream and may
# fail.
RESTRICT+=" strip"

DOCS=(
	CONTRIBUTING.md
	PATENTS
	README.md
	SECURITY.md
)

go_arch() {
	# By chance most portage arch names match Go
	local tc_arch=$(tc-arch $@)
	case "${tc_arch}" in
		x86)	echo 386;;
		x64-*)	echo amd64;;
		loong)	echo loong64;;
		mips) if use abi_mips_o32; then
				[[ $(tc-endian $@) = big ]] && echo mips || echo mipsle
			elif use abi_mips_n64; then
				[[ $(tc-endian $@) = big ]] && echo mips64 || echo mips64le
			fi ;;
		ppc64) [[ $(tc-endian $@) = big ]] && echo ppc64 || echo ppc64le ;;
		riscv) echo riscv64 ;;
		s390) echo s390x ;;
		*)		echo "${tc_arch}";;
	esac
}

go_arm() {
	case "${1:-${CHOST}}" in
		armv5*)	echo 5;;
		armv6*)	echo 6;;
		armv7*)	echo 7;;
		*)
			die "unknown GOARM for ${1:-${CHOST}}"
			;;
	esac
}

go_os() {
	case "${1:-${CHOST}}" in
		*-linux*)	echo linux;;
		*-darwin*)	echo darwin;;
		*-freebsd*)	echo freebsd;;
		*-netbsd*)	echo netbsd;;
		*-openbsd*)	echo openbsd;;
		*-solaris*)	echo solaris;;
		*-cygwin*|*-interix*|*-winnt*)
			echo windows
			;;
		*)
			die "unknown GOOS for ${1:-${CHOST}}"
			;;
	esac
}

go_tuple() {
	echo "$(go_os $@)_$(go_arch $@)"
}

go_cross_compile() {
	[[ $(go_tuple ${CBUILD}) != $(go_tuple) ]]
}

src_compile() {
	if has_version -b dev-lang/go; then
		export GOROOT_BOOTSTRAP="${BROOT}$(go env GOROOT)"
	elif has_version -b dev-lang/go-bootstrap; then
		export GOROOT_BOOTSTRAP="${BROOT}/usr/lib/go-bootstrap"
	else
		eerror "Go cannot be built without go or go-bootstrap installed"
		die "Should not be here, please report a bug"
	fi

	export GOROOT_FINAL="${EPREFIX}${GOROOT_VALUE}"
	export GOROOT="${PWD}"
	export GOBIN="${GOROOT}/bin"

	# Go's build script does not use BUILD/HOST/TARGET consistently. :(
	export GOHOSTARCH=$(go_arch ${CBUILD})
	export GOHOSTOS=$(go_os ${CBUILD})
	export CC=$(tc-getBUILD_CC)

	export GOARCH=$(go_arch)
	export GOOS=$(go_os)
	export CC_FOR_TARGET=$(tc-getCC)
	export CXX_FOR_TARGET=$(tc-getCXX)
	use arm && export GOARM=$(go_arm)
	use x86 && export GO386=$(usex cpu_flags_x86_sse2 '' 'softfloat')

	cd src
	bash -x ./make.bash || die "build failed"
}

src_test() {
	go_cross_compile && return 0

	cd src
	PATH="${GOBIN}:${PATH}" \
		./run.bash -no-rebuild || die "tests failed"
	cd ..
	rm -fr pkg/*_race || die
	rm -fr pkg/obj/go-build || die
}

src_install() {
	# There is a known issue which requires the source tree to be installed [1].
	# Once this is fixed, we can consider using the doc use flag to control
	# installing the doc and src directories.
	# The use of cp is deliberate in order to retain permissions
	# [1] https://golang.org/issue/2775
	dodir ${GOROOT_VALUE}
	cp -R api bin doc lib pkg misc src test "${ED}${GOROOT_VALUE}"
	einstalldocs

	# testdata directories are not needed on the installed system
	rm -fr $(find "${ED}${GOROOT_VALUE}" -iname testdata -type d -print)

	local bin_path
	if go_cross_compile; then
		bin_path="bin/$(go_tuple)"
	else
		bin_path=bin
	fi
	local f x
	for x in ${bin_path}/*; do
		f=${x##*/}
		dosym -r ${GOROOT_VALUE}/${bin_path}/${f} /usr/bin/${f}${PV_MINOR}
	done
}

pkg_preinst() {
	# prevent conflicting with ::gentoo repo version
	if portageq has_version "${EROOT:-/}" 'dev-lang/go::gentoo'; then
		rm -rf "${ED}"/usr/share/doc/* || die
	fi
}

pkg_postinst() {
	local pvr= lmv=0 upgrade=false
	for pvr in $REPLACING_VERSIONS; do
		[[ $pvr =~ ^([[:digit:]]+)\.([[:digit:]]+)(\.([[:digit:]]+))?(_.*)?(-.*)?$ ]] || true
		local mv="${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
		if (( $mv > $lmv )); then
			lmv=$mv
		fi
	done
	if (( $PV_MINOR > $lmv )); then
		upgrade=true
	fi
	if [[ $upgrade == true ]]; then
		local libPath="${EROOT}"/usr/lib/go
		local binPath="${EROOT}"/usr/bin/go
		if [[ ! -e $libPath && ! -e $binPath ]] || \
			[[ -L $libPath && -L $binPath ]]; then
			eselect go set go${PV_MINOR}
		fi
	fi

	elog
	elog "To switch between available Go version, execute as root:"
	elog "\teselect go set (go1.19|go1.20|...)"
	elog "ATTENTION: not compatible with dev-lang/go::gentoo version"
	elog

	[[ -z ${REPLACING_VERSIONS} ]] && return
	elog "After ${CATEGORY}/${PN} is updated it is recommended to rebuild"
	elog "all packages compiled with previous versions of ${CATEGORY}/${PN}"
	elog "due to the static linking nature of go."
	elog "If this is not done, the packages compiled with the older"
	elog "version of the compiler will not be updated until they are"
	elog "updated individually, which could mean they will have"
	elog "vulnerabilities."
	elog "Run 'emerge @golang-rebuild' to rebuild all 'go' packages"
	elog "See https://bugs.gentoo.org/752153 for more info"
}

pkg_postrm() {
	eselect go cleanup
}
