# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A concurrent garbage collected and typesafe programming language"
HOMEPAGE="https://go.dev"
SRC_URI="https://storage.googleapis.com/golang/go${PV//_/}.src.tar.gz "

LICENSE="BSD"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~loong ~mips ~ppc64 ~riscv ~s390 ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos ~x64-solaris"

IUSE="abi_mips_o32 abi_mips_n64 cpu_flags_x86_sse2"

PV_MAJOR2MINOR="$(ver_cut 1-2)"
PV_PATCH="$(ver_cut 3)"
SLOT="${PV_MAJOR2MINOR}/${PV_PATCH:-0}"

# the installation path is fixed to "${EPREFIX}${GOROOT_VALUE}"
GOROOT_VALUE="/usr/lib/go${PV_MAJOR2MINOR}"
S="${WORKDIR}"/go

# see https://go.dev/doc/go1.20#bootstrap
BOOTSTRAP_MIN_VER="1.17.13"

BDEPEND="
	|| (
		>=dev-lang/go-${BOOTSTRAP_MIN_VER}
		>=dev-lang/go-bootstrap-${BOOTSTRAP_MIN_VER}
	)
"
RDEPEND="
	app-eselect/eselect-go
	dev-libs/golang-rebuild-set
"

# the *.syso files have writable/executable stacks
QA_EXECSTACK='*.syso'

# Do not complain about CFLAGS, etc, since Go doesn't use them.
QA_FLAGS_IGNORED='.*'

# The tools in /usr/lib/go${PV_MAJOR2MINOR} should not cause the multilib-strict check to fail.
QA_MULTILIB_PATHS="usr/lib/go${PV_MAJOR2MINOR}/pkg/tool/.*/.*"

# This package triggers "unrecognized elf file(s)" notices on riscv.
# https://bugs.gentoo.org/794046
QA_PREBUILT='.*'

# Do not strip this package. Stripping is unsupported upstream and may fail.
RESTRICT="strip"

DOCS=(
	CONTRIBUTING.md
	PATENTS
	README.md
	SECURITY.md
)

go_arch() {
	# By chance most portage arch names match Go
	local tc_arch
	tc_arch="$(tc-arch "$1")"
	case "${tc_arch}" in
		arm64*) echo arm64 ;;
		loong)  echo loong64 ;;
		mips)
			if use abi_mips_o32; then
				[[ $(tc-endian "$1") == big ]] && echo mips || echo mipsle
			elif use abi_mips_n64; then
				[[ $(tc-endian "$1") == big ]] && echo mips64 || echo mips64le
			fi
			;;
		ppc64) [[ $(tc-endian "$1") == big ]] && echo ppc64 || echo ppc64le ;;
		riscv) echo riscv64 ;;
		s390)  echo s390x ;;
		x64-*) echo amd64 ;;
		x86)   echo 386 ;;
		*)     echo "${tc_arch}" ;;
	esac
}

go_arm() {
	local host="$CHOST"
	case "$host" in
		armv5*) echo 5 ;;
		armv6*) echo 6 ;;
		armv7*) echo 7 ;;
		*)
			die "unknown GOARM for $host"
			;;
	esac
}

go_os() {
	local host="${1:-$CHOST}"
	case "$host" in
		*-linux*)   echo linux ;;
		*-darwin*)  echo darwin ;;
		*-freebsd*) echo freebsd ;;
		*-netbsd*)  echo netbsd ;;
		*-openbsd*) echo openbsd ;;
		*-solaris*) echo solaris ;;
		*-cygwin*|*-interix*|*-winnt*)
			echo windows
			;;
		*)
			die "unknown GOOS for $host"
			;;
	esac
}

go_tuple() {
	echo "$(go_os "$1")_$(go_arch "$1")"
}

go_cross_compile() {
	[[ $(go_tuple "$CBUILD") != $(go_tuple) ]]
}

declare -g GO_LATEST_PVR
pkg_setup() {
	GO_LATEST_PVR="$(best_version -b dev-lang/go)"
}

src_compile() {
	local go_ver=0
	if [[ -n $GO_LATEST_PVR ]]; then
		go_ver="${GO_LATEST_PVR#dev-lang/go-}"
	fi
	if ver_test "$go_ver" -ge "$BOOTSTRAP_MIN_VER"; then
		go_ver="$(ver_cut 1-2 "$go_ver")"
		GOROOT_BOOTSTRAP="${BROOT}/usr/lib/go${go_ver}"
		# the make.bash will fallback to use the `go env GOROOT` to get the
		# GOROOT_BOOTSTRAP value if this one is incorrect.
	elif has_version -b dev-lang/go-bootstrap; then
		GOROOT_BOOTSTRAP="${BROOT}/usr/lib/go-bootstrap"
	else
		eerror "Go cannot be built without go or go-bootstrap installed"
		die "Should not be here, please report a bug"
	fi

	GOROOT_FINAL="${EPREFIX}${GOROOT_VALUE}"

	# Go's build script does not use BUILD/HOST/TARGET consistently. :(
	GOHOSTARCH=$(go_arch "$CBUILD")
	CC="$(tc-getBUILD_CC)"
	CXX="$(tc-getBUILD_CXX)"

	GOARCH=$(go_arch)
	GOOS=$(go_os)
	CC_FOR_TARGET=$(tc-getCC)
	CXX_FOR_TARGET=$(tc-getCXX)
	use arm && GOARM=$(go_arm) && export GOARM
	use x86 && GO386=$(usex cpu_flags_x86_sse2 '' 'softfloat') && export GO386

	export \
		GOROOT_BOOTSTRAP \
		GOROOT_FINAL \
		GOHOSTARCH \
		CC \
		CXX \
		GOARCH \
		GOOS \
		CC_FOR_TARGET \
		CXX_FOR_TARGET
	cd src || die
	bash -x ./make.bash || die "build failed"
}

src_test() {
	go_cross_compile && return 0

	cd src || die
	./run.bash -no-rebuild -k || die "tests failed"
}

src_install() {
	insinto "${GOROOT_VALUE}"
	doins VERSION
	# The use of cp is deliberate in order to retain permissions
	cp -R api bin doc lib pkg misc src test "${ED}${GOROOT_VALUE}"

	# remove the testdata dir, due to I cannot find a way to prevent the QA
	# warning messages about 'Unresolved soname dependencies' for those elf
	# files that is used for testing on different platforms, ;(
	local file
	while read -r file; do
		[[ -d "$file" ]] && rm -rf "$file" || die
	done < <(find "${ED}${GOROOT_VALUE}" -name testdata -type d)

	einstalldocs

	# do binary link
	local bin_path
	if go_cross_compile; then
		bin_path="bin/$(go_tuple)"
	else
		bin_path=bin
	fi
	local f x
	for x in "${bin_path}"/*; do
		f=${x##*/}
		dosym -r "${GOROOT_VALUE}/${bin_path}/${f}" "/usr/bin/${f}${PV_MAJOR2MINOR}"
	done
}

pkg_postinst() {
	# check if it's a minor version upgrade
	local pre_pvr="${GO_LATEST_PVR#dev-lang/go-}" upgrade=false \
		pre_pv_major2minor new_pv_major2minor
	pre_pv_major2minor=$(ver_cut 1-2 "$pre_pvr")
	if ver_test "$PV_MAJOR2MINOR" -gt "$pre_pv_major2minor"; then
		upgrade=true
		new_pv_major2minor=${PV_MAJOR2MINOR}
	else
		new_pv_major2minor=${pre_pv_major2minor}
	fi

	# try to switch to the new version if it's a minor version upgrade or it's a
	# fresh installation
	local eselect_ret=0 \
		libPath="${EROOT}"/usr/lib/go \
		binPath="${EROOT}"/usr/bin/go
	if [[ $upgrade == true && -L $libPath && -L $binPath ]] || \
		[[ ! -e $libPath && ! -e $binPath ]]; then
		eselect go set go${new_pv_major2minor} || eselect_ret=$?
		if [[ $eselect_ret == 0 ]]; then
			elog "[eselect] successfully switched to version: go${new_pv_major2minor}"
			elog
		else
			eerror "[eselect] switch to version go${new_pv_major2minor} error, please handle it manually!"
		fi
	fi

	# check if the ::gentoo version go pkg is installed,
	# cannot use has_version to check the pkg with an overlay name like
	# 'dev-lang/go::gentoo', so sad :(
	# check the vdb directly
	local vdb_path="${EROOT}/var/db/pkg" other_go_version_installed line
	while read -r line; do
		if [[ -f "${line}/repository" ]]; then
			if [[ "$(cat "${line}/repository")" != ryans ]]; then
				# TODO: is there any way to get the current repo_name?
				other_go_version_installed=1
				break
			fi
		fi
	done < <(find "${vdb_path}/dev-lang/" -maxdepth 1 -name 'go-1*' -type d)
	if [[ $other_go_version_installed == 1 ]]; then
		ewarn "It seems that other version of golang exists, you can"
		ewarn
		ewarn "1. Please uninstall the other version by executing:"
		ewarn "     # emerge -C dev-lang/go::gentoo # (or ::gentoo_prefix, or with other repo_name)"
		ewarn "   and use the eselect to select this slot enabled version:"
		ewarn "     # eselect go cleanup"
		ewarn "   to make this go package works."
		ewarn
		ewarn "2. Or, just mask this version if you don't want it by executing:"
		ewarn "     # echo $'\\\\n'\"dev-lang/go::ryans\" >>/etc/portage/package.mask/golang"
		ewarn "   and uninstall it."
		ewarn
		ewarn "If you want to switch back to the ::gentoo version again,"
		ewarn "please:"
		ewarn "  # emerge -C dev-lang/go       # remove all versions"
		ewarn "  # echo $'\\\\n'\"dev-lang/go::ryans\" >>/etc/portage/package.mask/golang"
		ewarn "  # emerge dev-lang/go::gentoo  # install it through go-bootstrap again"
		echo
	fi
	elog "To select/switch between available Go version, execute as root:"
	elog "  # eselect go set (go1.20|go1.21|...)"
	elog "ATTENTION: not compatible with dev-lang/go::gentoo (or ::gentoo_prefix) version"

	[[ -n ${REPLACING_VERSIONS} ]] || return
	elog
	elog "After ${CATEGORY}/${PN} is updated, it is recommended to rebuild"
	elog "all packages compiled with previous versions of ${CATEGORY}/${PN}"
	elog "due to the static linking nature of go."
	elog "If this is not done, the packages compiled with the older"
	elog "version of the compiler will not be updated until they are"
	elog "updated individually, which could mean they will have"
	elog "vulnerabilities."
	elog "Run 'emerge @golang-rebuild' to rebuild all 'go' packages."
	elog "See https://bugs.gentoo.org/752153 for more info"
}

pkg_postrm() {
	eselect go cleanup
}
