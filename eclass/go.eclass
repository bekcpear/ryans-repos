# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: go.eclass
# @MAINTAINER:
# Ryan Qian <i@bitbili.net>
# @AUTHOR:
# Ryan Qian <i@bitbili.net>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: basic eclass for building software written in golang
# @DESCRIPTION:
# This eclass provides basic settings and functions needed by software
# written in the go programming language.
#
# This eclass has three methods for offline building and one methods for online building:
#
# THREE OFFLINE BUILDING METHODS:
#
# ** priority: 1. > 2. > 3. **
#
# 1. for packages with the go.sum file which line number is less than GO_SUM_LIST_MAX (default to 100),
#    if the corresponding go.sum file exists in the 'files' directory with name 'go.sum.$PV', this ebuild
#    will automatically set the local proxy url for all modules in the 'go.sum' file. You just need to
#    add the GO_SUM_LIST_SRC_URI variable into the SRC_URI variable.
#
# @CODE
#
# inherit go
#
# SRC_URI="https://github.com/example-org/reponame/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
# SRC_URI+=" ${GO_SUM_LIST_SRC_URI}"
#
# @CODE
#
# 2. use project embedded 'vendor' directory to build.
#    just inherit this eclass, don't need to do other special works
#
# @CODE
#
# inherit go
#
# @CODE
#
# 3. use extra 'vendor' directory to offer offline building, the vendor tarball can
#    be generated by the script https://github.com/bekcpear/vendor-for-go .
#    The tarball should consist of the directory architecture:
#    (name quoted by '[]' means optional)
#
#      [any-parent-directory/]
#
#          vendor/
#
#          [go-mod-sum.diff]   # should and expected to be empty if
#                              # the upstream did `go mod tidy` before releasing
#
# @CODE
#
# inherit go
#
# SRC_URI="https://github.com/example-org/reponame/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
#  https://some.url/corresponding-vendor-path.tar.gz -> ${P}-vendor.tar.gz"
#
# @CODE
#
# THE ONLINE BUILDING METHOD:
#
# 1. If there is no corresponding 'go.sum.$PV' file in the 'files' directory and
#    also no embedded 'vendor' directory under the $S path.
#    This eclass will check whether the 'live' PROPERTY exists, if it is, this eclass
#    will use `go mod vendor` to generate the 'vendor' directory through the network
#    instead of checking the vendor tarball.
#
# @CODE
#
# inherit git-r3 go
#
# EGIT_REPO_URI="https://github.com/example-org/reponame.git"
#
# src_unpack() {
#   git-r3_src_unpack
#   go_set_go_cmd
#   go_setup_vendor
# }
#
# OR without using the git-r3 eclass and specifying the PROPERTIES manually:
# #PROPERTIES="live"
# #SRC_URI="https://github.com/example-org/reponame/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
# #src_unpack() {
# #  go_src_unpack # just omit this whole "src_unpack" function
# #}
#
# @CODE
#
#
# #############################################################
# #############################################################
#
# Why use this eclass instead of the offical go-module.eclass, please refer to
# https://github.com/bekcpear/ryans-repos/issues/4
#
# Since Go programs are statically linked, it is important that your ebuild's
# LICENSE= setting includes the licenses of all modules.
# This script will be helpful to get the job done:
# https://github.com/bekcpear/go-licenses-for-gentoo
#
if [[ -z ${_ECLASS_GO} ]]; then
_ECLASS_GO=1

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit edo version

BDEPEND=">=dev-lang/go-1.16"

EXPORT_FUNCTIONS src_unpack src_compile src_install

# @ECLASS_VARIABLE: GOFLAGS
# @DESCRIPTION:
# the default GOFLAGS.
# -buildvcs=false omits version control information
# -trimpath remove all file system paths from the resulting executable
# -v prints the names of packages as they are compiled
# -work prints the temporary work dir's name and don't delete it when exiting
# -x prints the commands
export GOFLAGS="-buildvcs=false -trimpath -v -work -x"

# @ECLASS_VARIABLE: EXTRA_GOFLAGS
# @DESCRIPTION:
# the extra GOFLAGS environment variable, default is empty,
# this value will be appended to the GOFLAGS if provided.
# Only valid when using the default src_compile of this eclass
# or 'go_build' function of this eclass.

# @ECLASS_VARIABLE: QA_FLAGS_IGNORED
# @INTERNAL
# @DESCRIPTION:
# ignore FLAGS due to go projects do not use them,
# this is a regex used by sed (without leading ^ and ending $).
QA_FLAGS_IGNORED='.*'

# Go packages should not be stripped with strip(1).
RESTRICT+=" strip"

# @ECLASS_VARIABLE: GO_LDFLAGS
# @DESCRIPTION:
# Flags pass to -ldflags, '-s' and '-w' flags will always be
# applied except calling go command directly.

# @ECLASS_VARIABLE: GO_SBIN
# @DESCRIPTION:
# names of binaries which should be installed as sbin

# @ECLASS_VARIABLE: GO_TAGS
# @DESCRIPTION:
# a comma-separated list of additional build tags to consider satisfied
# during the build
#
# @ECLASS_VARIABLE: GO_TARGET_PKGS
# @DESCRIPTION:
# A space-separated list of patterns which describe paths and target names
# of packages which should be built instead of the default '.' or './cmd/...' .
# The pattern has the following form:
# 	<PACKAGE-PATH>[ -> <TARGET-NAME>]
# <PACKAGE-PATH> is relative to the current temporary build dir (normally $S)
# <TARGET-NAME> is the binary name instead of the package path name
# e.g.:
# 	./main -> foo
# 	./cmd/bar

# @ECLASS_VARIABLE: GO_LDFLAGS_EXMAP
# @DESCRIPTION:
# Extra "variable name <-> output command" maps, the output command will be called
# and assign the standard output to the corresponding variable in src_compile phase.
# These variables will replace the corresponding formatted strings in GO_LDFLAGS.
# The formatted string should be like '@@VARIABLE-NAME@@'
# e.g.:
# 	GO_LDFLAGS_EXMAP[BUILD_DATE]="date '+%F %T%z'"
# 	GO_LDFLAGS="-X 'main.buildDate=@@BUILD_DATE@@'"
declare -A -g GO_LDFLAGS_EXMAP

# @ECLASS_VARIABLE: _GO_LDFLAGS_EXMAP_CACHE
# @INTERNAL
# @DESCRIPTION:
# cache for GO_LDFLAGS_EXMAP
declare -A -g _GO_LDFLAGS_EXMAP_CACHE

# @ECLASS_VARIABLE: GO_CMD
# @DESCRIPTION:
# The version matched Go command used to build packages.
# Default is 'go'.
# When dev-lang/go is installed from the 'ryans' repo, the slot is enabled,
# and the default is the latest version, may be restricted to the penultimate
# latest version due to the requirement of BDEPEND.
GO_CMD=go

# @ECLASS_VARIABLE: GO_SUM_LIST_MAX
# @DESCRIPTION:
# The max line number of go.sum which can be used to set a local proxy,
# default to 100. This variable should be set before the eclass inherited.
: ${GO_SUM_LIST_MAX:=100}

# @ECLASS_VARIABLE: GO_SUM_LIST_SRC_URI
# @DESCRIPTION:
# SRC_URI for go.sum entiries
GO_SUM_LIST_SRC_URI=

# @ECLASS_VARIABLE: GO_SUM_LIST_SRC_URI_R
# @INTERNAL
# @DESCRIPTION:
# (internal variable) reversed map for GO_SUM_LIST_SRC_URI
declare -A -g GO_SUM_LIST_SRC_URI_R

# @FUNCTION: _go_escape_go_sum_path
# @INTERNAL
# @DESCRIPTION:
# convert all capital letters in path to '!<lowercase>' format
_go_escape_go_sum_path() {
	local path="${1}" l
	while [[ "${path}" =~ (.*)([[:upper:]])(.*) ]]; do
		l=${BASH_REMATCH[2]@L}
		path="${BASH_REMATCH[1]}!${l}${BASH_REMATCH[3]}"
	done
	echo -n "${path}"
}

# @FUNCTION: _go_set_go_sum_list_src_uri
# @INTERNAL
# @DESCRIPTION:
# set GO_SUM_LIST_SRC_URI
_go_set_go_sum_list_src_uri() {
	debug-print-function "${FUNCNAME}" "${@}"

	if [[ -n ${GO_SUM_LIST_SRC_URI} ]]; then
		return 0
	fi

	local _go_sum_list_file="${EBUILD%/*}/files/go.sum.$PV"
	if [[ ! -f "${_go_sum_list_file}" ]]; then
		return 0
	fi
	local -a _go_sum_list
	while read -r line; do
		_go_sum_list+=("${line}")
	done <"${_go_sum_list_file}"
	if [[ ${#_go_sum_list[@]} -gt ${GO_SUM_LIST_MAX} ]]; then
		return 0
	fi

	local _distfile_name _src_uri _ver _ext
	for line in "${_go_sum_list[@]}"; do
		<<<$(_go_escape_go_sum_path "${line}") read -r path ver _
		_ext=".zip"
		_ver=${ver%/go.mod}
		if [[ ${_ver} != ${ver} ]]; then
			_ext=".mod"
		fi
		path="${path}/@v/${_ver}${_ext}"
		_distfile_name="${path//\//%2F}"
		eval "GO_SUM_LIST_SRC_URI_R['${_distfile_name}']='${path}'"
		GO_SUM_LIST_SRC_URI+=" mirror://goproxy/${path} -> ${_distfile_name}"
	done

	export GOPROXY="file://${T}/go-proxy"
}
_go_set_go_sum_list_src_uri

# @FUNCTION: go_version
# @USAGE: [-f]
# @DESCRIPTION:
# Get version with format major.minor of the current executing go binary,
# optionally specify -f to show the full version with the patch number.
go_version() {
	debug-print-function "${FUNCNAME}" "${@}"

	local output=$($GO_CMD version | cut -d' ' -f3) \
		major= minor= patch=

	IFS='.' read major minor patch <<<"$output"
	major=${major#go}

	if [[ $1 == '-f' ]] && [[ -n $patch ]]; then
		output="${major}.${minor}.${patch}"
	else
		output="${major}.${minor}"
	fi

	echo -n $output
}

# @FUNCTION: go_set_go_cmd
# @DESCRIPTION:
# Try to get the version matched Go command, this is useful when the
# go module to compile is restricted to the penultimate latest go version,
# only functional when used with multi-version support of Go from
# the ryans repository or other similar.
# This function is called within the src_unpack phase by default.
go_set_go_cmd() {
	debug-print-function "${FUNCNAME}" "${@}"

	local goCmdPath=
	local -a versions=() goCmds=()
	for goCmdPath in $(ls -1v "${EROOT}"/usr/bin/go[[:digit:]].[[:digit:]]* 2>/dev/null); do
		[[ -x "$goCmdPath" ]] || continue
		goCmds+=( ${goCmdPath} )
		versions+=( ${goCmdPath##*go} )
	done

	if [[ ${#versions[@]} -eq 0 ]]; then
		# just return it if has no multi-version go binaries
		return 0
	fi

	local _bdeps bdeps i d _ver_range _opt _ver _slot use usemark
	local -a contained
	local -i depth=0
	local ver_range slot
	_bdeps=( $(echo "$BDEPEND" | sed -E 's@(^|[[:space:]])[>=<~]{0,2}[[:alnum:]_\.-]+/[^g][^o][^[:space:]]*@ @g') )
	contained[0]=1
	for d in ${_bdeps[@]}; do
		if [[ $d =~ ^(!?)([[:alpha:]][[:alnum:]]+)\?$ ]]; then
			usemark=${BASH_REMATCH[1]}
			use=${BASH_REMATCH[2]}
			(( depth+=1 ))
			if eval "$usemark use $use"; then
				eval "contained[$depth]=1"
			else
				eval "contained[$depth]=0"
			fi
		elif [[ $d == "(" ]]; then
			:
		elif [[ $d == ")" ]]; then
			(( depth-=1 ))
		elif [[ $d == "||" ]]; then
			# ignore it due to dev-lang/go dependency should not inside this
			(( depth+=1 ))
			eval "contained[$depth]=0"
		else
			if [[ ${contained[$depth]} == 1 ]]; then
				bdeps+=( "$d" )
			fi
		fi
	done
	for d in ${bdeps[@]}; do
		if [[ $d =~ ([>=<~]*)dev-lang/go(-([^[:space:]:]+))?(:([^[:space:]=]*))? ]]; then
			_opt=${BASH_REMATCH[1]}
			_ver=${BASH_REMATCH[3]}
			_slot="${BASH_REMATCH[5]}"

			if [[ $_opt =~ ^[=~] && -n $_ver ]]; then
				ver_range="= $_ver"
				# break loop when caught an exact version
				break
			elif [[ $_opt =~ [\>\<] && -n $_ver ]]; then
				_ver_range="$_opt $_ver"
			elif [[ -z $_slot ]]; then
				_ver_range=
			elif [[ -n $_slot ]]; then
				slot=$_slot
			fi

			if [[ -n $_ver_range ]]; then
				ver_range=$(version_make_range "$ver_range" "$_ver_range")
			fi
		fi
	done

	local ver oS oE vS vE
	# match non-zero slot first then ver_range
	for (( i = 0; i < ${#versions[@]}; i++ )); do
		ver=${versions[$i]}
		if [[ -n $slot && $slot != 0 ]]; then
			if ! version_compare e $ver $slot; then
				continue
			fi
		elif [[ -n $ver_range ]]; then
			read -r oS vS oE vE <<<"$ver_range"
			if [[ $oS == "=" ]]; then
				VERSION_COMPARED_PARTS="minor"
				if  ! version_compare e $ver $vS; then
					continue
				fi
			else
				if [[ ${oS:1:1} == "=" ]]; then
					if version_compare l $ver $vS; then
						continue
					fi
				else
					if version_compare le $ver $vS; then
						continue
					fi
				fi
				if [[ -n $oE ]]; then
					if [[ ${oE:1:1} == "=" ]]; then
						if version_compare g $ver $vE; then
							continue
						fi
					else
						if version_compare ge $ver $vE; then
							continue
						fi
					fi
				fi
			fi
		fi
		GO_CMD="${goCmds[$i]}"
	done
}

# @FUNCTION: go_setup_proxy
# @DESCRIPTION:
# Setup the local proxy for downloading go modules.
go_setup_proxy() {
	debug-print-function "${FUNCNAME}" "${@}"

	local -a _default_A
	local _f _go_proxy_dir="${GOPROXY#file:\/\/}"

	mkdir -p ${_go_proxy_dir} || die

	for f in ${A}; do
		_f="${GO_SUM_LIST_SRC_URI_R[${f}]}"
		if [[ -n ${_f} ]]; then
			_f="${_go_proxy_dir}/${_f}"
			mkdir -p "$(dirname ${_f})" || die
			ln -sf ${DISTDIR}/${f} ${_f} || die
		else
			_default_A+=("${f}")
		fi
	done

	if [[ "$1" == "i" ]]; then
		declare -p _default_A
	fi
}

# @FUNCTION: go_setup_vendor
# @DESCRIPTION:
# setup vendor directory
go_setup_vendor() {
	debug-print-function "${FUNCNAME}" "${@}"

	if [[ ! -d "${S}/vendor" ]]; then
		if [[ ${PROPERTIES} =~ (^|[[:space:]])live([[:space:]]|$) ]]; then
			# Golang does not support the 'socks5h://' schema for http[s]_proxy env variable:
			#   https://github.com/golang/go/blob/9123221ccf3c80c741ead5b6f2e960573b1676b9/src/vendor/golang.org/x/net/http/httpproxy/proxy.go#L152-L159
			# while libcurl supports it:
			#   https://github.com/curl/curl/blob/ae98b85020094fb04eee7e7b4ec4eb1a38a98b98/docs/libcurl/opts/CURLOPT_PROXY.3#L48-L59
			# So, if a 'https_proxy=socks5h://127.0.0.1:1080' env has been set in the
			# make.conf to make curl (assuming curl is the current download command) to
			# download all packages through the proxy, go-module_live_vendor will
			# fail.
			# The only difference between these two schemas is, 'socks5h' will solve
			# the hostname via the proxy while 'socks5' will not. I think it's ok to
			# fallback 'socks5h' to 'socks5' for `go vendor` command and warn user,
			# until golang supports it.
			# related to issue: https://github.com/golang/go/issues/24135
			local hp
			local -a hps
			if [[ -n $HTTP_PROXY ]]; then
				hps+=( HTTP_PROXY )
			elif [[ -n $http_proxy ]]; then
				hps+=( http_proxy )
			fi
			if [[ -n $HTTPS_PROXY ]]; then
				hps+=( HTTPS_PROXY )
			elif [[ -n $https_proxy ]]; then
				hps+=( https_proxy )
			fi
			for hp in "${hps[@]}"; do
				if [[ -n ${!hp} ]] && [[ ${!hp} =~ ^socks5h:// ]]; then
					set -- export ${hp}="socks5${!hp#socks5h}"
					ewarn "golang does not support the 'socks5h://' schema for '${hp}', fallback to the 'socks5://' schema"
					einfo "${@}"
					"${@}"
				fi
			done
			pushd "${S}" >/dev/null || die
			# We don't care the compatibility with other go versions due to it's a temporary dir and the
			# only purpose here is to build this package under current version of the go binary,
			# so specify a compatible go version with current version number here to avoid incompatibility,
			# such as go1.16 and go1.17 has different build list calculation methods (https://go.dev/ref/mod#graph-pruning).
			edo $GO_CMD mod tidy -compat $(go_version)
			edo $GO_CMD mod vendor
			popd >/dev/null || die
		else
			local -a vendors
			local vendor go_mod_sum_diff
			vendors=($(find "${WORKDIR}" -maxdepth 2 -name 'vendor' 2>/dev/null || true))
			if [[ ${#vendors[@]} -gt 0 ]]; then
				vendor="${vendors[0]}"
				mv "${vendor}" "${S}" || die
				go_mod_sum_diff="$(dirname ${vendor})/go-mod-sum.diff"
				if [[ -s "${go_mod_sum_diff}" ]]; then
					pushd "${S}" >/dev/null || die
					eapply "${go_mod_sum_diff}"
					popd >/dev/null || die
				fi
			fi
		fi
	fi
}

# @FUNCTION: go_src_unpack
# @DESCRIPTION:
# src_unpack
go_src_unpack() {
	debug-print-function "${FUNCNAME}" "${@}"

	go_set_go_cmd

	if [[ -n ${GO_SUM_LIST_SRC_URI} ]]; then
		# prepare local proxy
		eval "$(go_setup_proxy i)" || die
		for f in "${_default_A[@]}"; do
			unpack "${f}"
		done
	else
		# prepare vendor directory
		default
		go_setup_vendor
	fi
}

# @FUNCTION: _go_print_cmd
# @INTERNAL
# @USAGE: <message>...
# @DESCRIPTION:
# print the command and arguments with a pretty format
_go_print_cmd() {
	local msg is_cmd
	echo -ne "\x1b[32;01m===\x1b[0m"
	for msg; do
		if [[ ${msg} =~ [[:space:]] ]] && [[ -n ${is_cmd} ]]; then
			msg="\"${msg//\"/\\\"}\""
		elif [[ ${msg} == $GO_CMD ]]; then
			is_cmd=1
		fi
		echo -ne " ${msg}"
	done
	echo
}

# @FUNCTION: go_build
# @USAGE: [-o <output>] <package>...
# @DESCRIPTION:
# parse necessary arguments for go build and build packages,
# the binaries will be installed into the ${T}/go-bin/ directory by default.
go_build() {
	debug-print-function "${FUNCNAME}" "${@}"

	local go_ldflags="${GO_LDFLAGS}"

	[[ "${go_ldflags}" =~ (^|[[:space:]])-w([[:space:]]|$) ]] || go_ldflags="-w ${go_ldflags}"
	[[ "${go_ldflags}" =~ (^|[[:space:]])-s([[:space:]]|$) ]] || go_ldflags="-s ${go_ldflags}"

	local key value
	for key in "${!GO_LDFLAGS_EXMAP[@]}"; do
		if [[ -n "${_GO_LDFLAGS_EXMAP_CACHE[$key]}" ]]; then
			value="${_GO_LDFLAGS_EXMAP_CACHE[$key]}"
		else
			value=$(eval "${GO_LDFLAGS_EXMAP[$key]}" || true)
			if [[ -z ${value} ]]; then
				die "the stdout of command '$GO_LDFLAGS_EXMAP[$key]' (GO_LDFLAGS_EXMAP[$key]) is empty"
			fi
			_GO_LDFLAGS_EXMAP_CACHE[$key]=${value}
		fi
		go_ldflags=$(<<<"${go_ldflags}" sed "s/@@${key}@@/${value}/g")
	done

	local output="${T}/go-bin/"
	local -a args
	while :; do
		case "${1}" in
			-o)
				shift
				output="${1}"
				shift
				;;
			"")
				break
				;;
			*)
				args+=( "${1}" )
				shift
				;;
		esac
	done
	set -- "${args[@]}"

	GOFLAGS="${GOFLAGS}${EXTRA_GOFLAGS:+ }${EXTRA_GOFLAGS}"
	set -- $GO_CMD build -o "${output}" ${GO_TAGS:+-tags} ${GO_TAGS} -ldflags "${go_ldflags}" "${@}"
	_go_print_cmd "      GOFLAGS:" "${GOFLAGS}"
	_go_print_cmd "Build command:" "${@}"
	"${@}" || die
}

# @FUNCTION: go_src_compile
# @DESCRIPTION:
# src_compile
go_src_compile() {
	debug-print-function "${FUNCNAME}" "${@}"

	if [[ -d "cmd" ]] && [[ -z ${GO_TARGET_PKGS} ]] && \
		[[ $(find cmd/ -maxdepth 2 -type f -name '*.go' -exec \
			grep -E '^package[[:space:]]+main([[:space:]]|$)' '{}' \; 2>/dev/null || true) != "" ]]; then
		go_build ./cmd/...
	elif [[ -z ${GO_TARGET_PKGS} ]]; then
		go_build .
	else
		local pkg_path
		local -a pkg_paths
		set -- ${GO_TARGET_PKGS}
		while :; do
			case "${1}" in
				'')
					break
					;;
				'->')
					shift
					go_build -o "${T}/go-bin/${1}" ${pkg_path}
					pkg_path=
					shift
					;;
				*)
					if [[ ${pkg_path} != "" ]]; then
						pkg_paths+=( "${pkg_path}" )
						pkg_path=
					fi
					pkg_path="${1}"
					shift
					;;
			esac
		done
		if [[ ${pkg_path} != "" ]]; then
			pkg_paths+=( "${pkg_path}" )
		fi
		if [[ ${#pkg_paths[@]} -gt 0 ]]; then
			go_build "${pkg_paths[@]}"
		fi
	fi
}

# @FUNCTION: go_src_install
# @DESCRIPTION:
# src_install
go_src_install() {
	debug-print-function "${FUNCNAME}" "${@}"

	pushd "${T}"/go-bin >/dev/null || die

	local _sb _sbin
	if [[ $(declare -p GO_SBIN 2>/dev/null) =~ declare[[:space:]]+-a ]]; then
		_sbin="${GO_SBIN[*]}"
	else
		_sbin="${GO_SBIN}"
	fi
	for _sb in ${_sbin}; do
		if ls ${_sb} &>/dev/null; then
			dosbin ${_sb}
			rm -f ${_sb} || die
		fi
	done

	dobin *

	popd >/dev/null || die
}

fi
