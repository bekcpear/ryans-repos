#!/usr/bin/env bash
#

set -e

DEFAULT_SOCKFILE="/var/run/tailscale/tailscaled.sock"

declare -a sockfiles=() instanceNames=()
sockfiles=( $(ls -1v ${DEFAULT_SOCKFILE}*) )
for sockfile in "${sockfiles[@]}"; do
	instanceName=${sockfile#$DEFAULT_SOCKFILE}
	: ${instanceName:=default}
	instanceNames+=($instanceName)
done

selectedInstance=$TAILSCALE_INSTANCE
selectedSockfile=$DEFAULT_SOCKFILE
declare -a args=()
if [[ ${#sockfiles[@]} -gt 1 ]]; then
	while :; do
		if [[ $1 == --ins ]]; then
			shift
			selectedInstance=$1
		else
			args+=( "$1" )
		fi
		shift
	done
	if [[ -z $selectedInstance ]]; then
		echo -ne "\x1b[1m\x1b[33m" >&2
		echo     "There are multiple tailscale instances running:" >&2
		for instanceName in ${instanceNames[@]}; do
			echo "  $instanceName" >&2
		done
		echo     "since you didn't make a selection, the default instance will be used." >&2
		echo     "You can specify it with the '--ins <name>' argument at any position," >&2
		echo     "                or by the TAILSCALE_INSTANCE environment variable." >&2
		echo -e  "\x1b[0m" >&2
	else
		for (( i=0; i<${#instanceNames[@]}; i++ )); do
			if [[ $selectedInstance == ${instanceNames[$i]} ]]; then
				selectedSockfile=${sockfiles[$i]}
				break
			fi
		done
	fi
fi

set -- @EROOT@/usr/libexec/tailscale -socket="$selectedSockfile" "${args[@]}"
exec "$@"
