# Copyright 2023
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: version.eclass
# @MAINTAINER:
# Ryan Qian <i@bitbili.net>
# @AUTHOR:
# Ryan Qian <i@bitbili.net>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: functions to handle the version number
# @DESCRIPTION:
# This eclass provides functions to handle the version number.

if [[ -z ${_ECLASS_VERSION} ]]; then
_ECLASS_VERSION=1

# @ECLASS_VARIABLE: VERSION_COMPARED_PARTS
# @DESCRIPTION:
# the version parts to compare, default is the full parts,
# avaliable values are:
#   major  # major parts
#   minor  # major and minor parts
#   patch  # major, minor and patch parts
#   full   # major, minor, patch and pre-release parts
VERSION_COMPARED_PARTS="full"

# @FUNCTION: _version_compare_ver
# @INTERNAL
# @DESCRIPTION:
# _version_compare_ver sub function
_version_compare_ver() {
	debug-print-function "${FUNCNAME}" "${@}"

	local v0=${1} v1=${2} is_num=1 res=
	if [[ ! ${v0} =~ ^[0-9]+$ ]] || [[ ! ${v1} =~ ^[0-9]+$ ]]; then
		is_num=0
		: "${v0/-1/\\/}"
		: "${v1/-1/\\/}"
	fi
	if [[ ${is_num} == 1 ]]; then
		if (( ${v0} > ${v1} )); then
			res="g"
		elif (( ${v0} == ${v1} )); then
			res="e"
		elif (( ${v0} < ${v1} )); then
			res="l"
		fi
	else
		if [[ ${v0} > ${v1} ]]; then
			res="g"
		elif [[ ${v0} == ${v1} ]]; then
			res="e"
		elif [[ ${v0} < ${v1} ]]; then
			res="l"
		fi
	fi
	echo -n "${res}"
}

# @FUNCTION: _version_compare
# @INTERNAL
# @DESCRIPTION:
# _version_compare sub function
_version_compare() {
	debug-print-function "${FUNCNAME}" "${@}"

	local v0 v1 vv0 vv1 len _len res
	OIFS=$IFS; IFS="."
	v0=(${1}) v1=(${2})
	IFS=$OIFS
	if [[ ${#v0[@]} -ge ${#v1[@]} ]]; then
		len=${#v0[@]}
	else
		len=${#v1[@]}
	fi
	case $VERSION_COMPARED_PARTS in
		major)
			_len=1
			;;
		minor)
			_len=2
			;;
		patch)
			_len=3
			;;
	esac
	if [[ -n $_len && $_len -lt $len ]]; then
		len=$_len
	fi
	for (( i=0; i<${len}; i++ )); do
		vv0=${v0[$i]:--1}
		vv1=${v1[$i]:--1}
		res=$(_version_compare_ver ${vv0} ${vv1})
		if [[ ${res} != "e" ]]; then
			break
		fi
	done
	echo -n "${res}"
}

# @FUNCTION: version_compare
# @USAGE: g|ge|l|le|e STRING0 STRING1
# @DESCRIPTION:
# Compare the version numbers contained in the two strings to determine their precedence
# according to the specifications defined in https://semver.org/spec/v2.0.0.html
# The build metadata will be ignored.
#
# The prefixed package name will be removed automatically if exists.
#
# options:
#
#   g:      compare if the version contained in STRING0 is greater than the version in STRING1
#   ge:     compare if the version contained in STRING0 is greater than or equal to the version in STRING1
#   l:      compare if the version contained in STRING0 is less than the version in STRING1
#   le      compare if the version contained in STRING0 is less than or equal to the version in STRING1
#   e:      compare if the version contained in STRING0 is equal to the version in STRING1
#
# The return code is
#
#   0:      when the above comparison holds
#   1:      when the above comparison does not hold
#
version_compare() {
	debug-print-function "${FUNCNAME}" "${@}"

	local LC_ALL=C
	local action result
	case ${1} in
		g|ge|l|le|e)
			action="${1}"
			;;
		*)
			die "unexpected argument '${1}'"
			;;
	esac
	shift

	local -a str0 str1
	local str0_pkgname str0_ver str0_pre
	local str1_pkgname str1_ver str1_pre

	OIFS=$IFS; IFS="-"
	str0=( ${1} ) str1=( ${2} )
	IFS=$OIFS

	for _str in "str0" "str1"; do
		local _strA="${_str}[@]" _strV="${_str}_ver" _strP="${_str}_pre" _strN="${_str}_pkgname"
		for _s in "${!_strA}"; do
			if [[ -n ${!_strV} ]]; then
				eval "${_str}_pre=\"${_s}\""
			elif [[ ${_s} =~ ^[vV]?[0-9]+\.? ]]; then
				_s="${_s#v}"
				eval "${_str}_ver=\"${_s#V}\""
			else
				if [[ -n ${!_strN} ]]; then
					eval "${_str}_pkgname+=\"-\""
				fi
				eval "${_str}_pkgname+=\"${_s}\""
			fi
		done
	done

	if [[ ${str0_pkgname} != ${str1_pkgname} ]]; then
		die "compare with different package names '${str0_pkgname}', '${str1_pkgname}'"
	fi

	result=$(_version_compare ${str0_ver} ${str1_ver})
	if [[ ${result} == "e" ]]; then
		result=$(_version_compare ${str0_pre:-zzzz} ${str1_pre:-zzzz})
	fi

	if [[ ${result} =~ [${action}] ]]; then
		return 0
	else
		return 1
	fi
}

# @FUNCTION: version_make_range
# @USAGE: CURRENT_RANGE NEW_CONDITION
# @DESCRIPTION:
# create a version range through the NEW_CONDITION
# input format:
#   CURRENT_RANGE: ">[=] version-str <[=] version-str"
#   NEW_CONDITION: "(>|<)[=] version-str"
# output:
#   NEW_RANGE: ">[=] version-str <[=] version-str"
version_make_range() {
	debug-print-function "${FUNCNAME}" "${@}"

	if [[ -z $2 ]]; then
		die "no new condition provided"
	fi

	local oS vS oE vE o v equal replace
	read -r oS vS oE vE <<<"$1"
	read -r o v <<<"$2"
	if [[ ! $o =~ ^[\>\<]=?$ ]] || ! version_is_valid $v; then
		die "wrong format of the new condition"
	fi
	if [[ ${o:1:1} == "=" ]]; then
		equal=1
	fi
	case ${o:0:1} in
		">")
			if [[ -z $oS ]]; then
				replace=1
			elif [[ ${oS:1:1} == "=" ]] && \
				version_compare ge $v $vS; then
				replace=1
			else
				if [[ -n $equal ]] && \
					version_compare g $v $vS; then
					replace=1
				elif version_compare ge $v $vS; then
					replace=1
				fi
			fi
			if [[ -n $replace ]]; then
				oS=$o
				vS=$v
			fi
			;;
		"<")
			if [[ -z $oE ]]; then
				replace=1
			elif [[ ${oE:1:1} == "=" ]] && \
				version_compare le $v $vE; then
				replace=1
			else
				if [[ -n $equal ]] && \
					version_compare le $v $vE; then
					replace=1
				elif version_compare l $v $vE; then
					replace=1
				fi
			fi
			if [[ -n $replace ]]; then
				oE=$o
				vE=$v
			fi
			;;
	esac

	echo -n "${oS:->=} ${vS:-0} ${oE:-<=} ${vE:-9999}"
}

# @FUNCTION: version_is_valid
# @USAGE: version-str
# @DESCRIPTION:
# check the version-str is a valid semantic version
version_is_valid() {
	# TODO
	:
}

fi
