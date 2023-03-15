#!/usr/bin/env bash
#
# this is a script to fix my previous mis-configured paths
# it only executes once

default_dir="@EPREFIX@/var/lib/tailscale"

if [[ -d "${default_dir}/ex-instances.d" ]]; then
	exit 0
fi

pushd "${default_dir}" &>/dev/null

warn() {
	echo -en "\x1b[33m\x1b[1m  *  \x1b[0m" >&2
	echo "$@" >&2
}

docp() {
	local _default_state_c=$1 _default_state=$2
	if [[ -f $_default_state_c ]]; then
		if [[ -f $_default_state && $(wc -c $_default_state | cut -d' ' -f1) -lt 10 ]] || \
			[[ ! -f $_default_state ]]; then
			cp -a "$_default_state_c" "$_default_state"
		else
			warn "Existing a tailscale state in the path '@EPREFIX@/var/lib/tailscale/tailscaled.d',"
			warn "this is an improper configuration which conflicts with previous and official versions,"
			warn "so, I decide to revert my previous commit and back the default instance to use its default"
			warn "state path, only leave customized instances with their new state paths."
			warn "But there is also a configured state file with path '@EPREFIX@/var/lib/tailscale/tailscaled.state',"
			warn "so I cannot resolve it automatically."
		fi
	fi
}

docp "tailscaled.d/tailscaled.state" "tailscaled.state"

mkdir -p ex-instances.d
while read -r folder; do
	_theInstanceName=${folder#tailscaled.d.}
	if [[ -z $_theInstanceName ]]; then
		continue
	fi
	mkdir -p "ex-instances.d/$_theInstanceName"
	docp "${folder}/tailscaled.state" "ex-instances.d/${_theInstanceName}/tailscaled.state"
done <<<"$(ls -1dv tailscaled.d.* 2>/dev/null)"

popd &>/dev/null || true
