# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm.eclass
# @MAINTAINER:
# bekcpear <i@bitbili.net>
# @AUTHOR:
# bekcpear <i@bitbili.net>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: set a basic environment for NPM
# @DESCRIPTION:
# This eclass provides functions to build nodejs package via NPM offline.

# @EXAMPLE:
#
# @CODE
#
# inherit npm
#
# NPM_RESOLVED=(
#     "@babel/generator/-/generator-7.13.9.tgz"
#     "@babel/helper-annotate-as-pure/-/helper-annotate-as-pure-7.12.13.tgz"
# )
#
# npm_set_globals
# MY_SHAPATCH_SUFFIX="npm-lockfile-to-sha512"
#
# SRC_URI="https://github.com/example/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
#         "https://github.com/bekcpear/npm-lockfile-to-sha512.sh/archive/refs/tags/${P}.tar.gz -> ${P}-${MY_SHAPATCH_SUFFIX}.tar.gz"
#          ${NPM_RESOLVED_SRC_URI}"
#
# PATCHES=("${WORKDIR}/${MY_SHAPATCH_SUFFIX}.sh-${P}/${MY_SHAPATCH_SUFFIX}.diff")
#
# src_compile() {
#     npm_set_config
#     ...
# }
#
# @CODE

if [[ ! ${_NPM_ECLASS} ]]; then

case ${EAPI} in
	7|8) ;;
	*) die "EAPI ${EAPI} unsupported."
esac

BDEPEND=">=net-libs/nodejs-16.6[npm]"

EXPORT_FUNCTIONS src_unpack

# @ECLASS_VARIABLE: NPM_RESOLVED
# @REQUIRED
# @DESCRIPTION:
# This is an array based on package-lock.json/npm-shrinkwrap.json content
# from inside the target package.
# e.g.:
#   `jq '.packages[].resolved' package-lock.json | sed -E '/^null$/d;s@^\"https://[^/]+/(.+)\"$@\"\1\"@' | sort -u`

# @ECLASS_VARIABLE: NPM_RESOLVED_SRC_URI
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Coverted real src_uri and corresponding filename.

# @ECLASS_VARIABLE: _NPM_RESOLVED_TEST
# @INTERNAL
# @DESCRIPTION:
# Used to test distfiles belonging to NPM or not
declare -A -g _NPM_RESOLVED_TEST

# @ECLASS_VARIABLE: _NPM_CACHE_DIR
# @INTERNAL
# @DESCRIPTION:
# The temporary cache directory for NPM
_NPM_CACHE_DIR="${T}/npm-cache/"

# @ECLASS_VARIABLE: _NPM
# @INTERNAL
# @DESCRIPTION:
# NPM command
_NPM="npm"

# @FUNCTION: npm_set_globals
# @DESCRIPTION:
# Generate real src_uri variables and set npm registry
npm_set_globals() {
	debug-print-function "${FUNCNAME}" "$@"

	local line
	for line in "${NPM_RESOLVED[@]}"; do
		_distfile="${line//\//:2F}"
		NPM_RESOLVED_SRC_URI+=" mirror://npm/${line} -> ${_distfile}"$'\n'
		_NPM_RESOLVED_TEST[${_distfile}]=1
	done

	_NPM_SET_GLOBALS_CALLED=1
}

# @FUNCTION: _npm_set_cache_dir
# @INTERNAL
# @DESCRIPTION:
# set the config of NPM cache dir
_npm_set_cache_dir() {
	${_NPM} config set cache "${_NPM_CACHE_DIR}" || die
}

# @FUNCTION: _npm_add_cache_before
# @INTERNAL
# @DESCRIPTION:
# set env before adding cache
_npm_add_cache_before() {
	if [[ ! ${_NPM_SET_GLOBALS_CALLED} ]]; then
		die "npm_set_globals must be called in global scope!"
	fi
	mkdir -p "${_NPM_CACHE_DIR}" || die
	_npm_set_cache_dir
	einfo "Collecting npm tarballs ..."
}

# @FUNCTION: _npm_add_cache
# @INTERNAL
# @DESCRIPTION:
# increase the path args of NPM tarballs
_npm_add_cache() {
	debug-print-function "${FUNCNAME}" "$@"

	_NPM_TARBALLS+=" ${DISTDIR}/${1}"
}

# @FUNCTION: _npm_add_cache_after
# @INTERNAL
# @DESCRIPTION:
# add the NPM cache to the temp dir
_npm_add_cache_after() {
	debug-print-function "${FUNCNAME}" "$@"

	einfo "Adding npm cache data ..."
	${_NPM} cache add ${_NPM_TARBALLS}
}

# @FUNCTION: npm_add_cache
# @DESCRIPTION:
# Add the local npm cache.
# If your ebuild redefines src_unpack you need to call this function
# in src_unpack phrase.
#
# Notice:
#   npm will add local tarball to cache with default sha512sum only.
#   Please convert sha1 to sha512 of the file package-lock.json or npm-shrinkwrap.json
#   to make npm works fine.
#   script: https://github.com/bekcpear/npm-lockfile-to-sha512.sh
npm_add_cache() {
	debug-print-function "${FUNCNAME}" "$@"

	_npm_add_cache_before

	local f
	for f in ${A}; do
		if [[ -n ${_NPM_RESOLVED_TEST["${f}"]} ]]; then
			_npm_add_cache "${f}"
		fi
	done

	_npm_add_cache_after
}

# @FUNCTION: npm_src_unpack
# @DESCRIPTION:
# Add the local npm cache and unpack other targets.
npm_src_unpack() {
	debug-print-function "${FUNCNAME}" "$@"

	_npm_add_cache_before

	local f
	for f in ${A}; do
		if [[ -n ${_NPM_RESOLVED_TEST["${f}"]} ]]; then
			_npm_add_cache "${f}"
		else
			unpack "${f}"
		fi
	done

	_npm_add_cache_after
}

# @FUNCTION: npm_set_config
# @DESCRIPTION:
# Configure npm to make it can do as expected.
# It's necessary!
npm_set_config() {
	debug-print-function "${FUNCNAME}" "$@"

	_npm_set_cache_dir
	${_NPM} config set offline true
	${_NPM} config set audit false
	${_NPM} config set fund false
	${_NPM} config list -l
}

_NPM_ECLASS=1
fi
