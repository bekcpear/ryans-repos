#!/usr/bin/env bash
#

set -e

DEFAULT_SOCKFILE="/var/run/tailscale/tailscaled.sock"

declare -a sockfiles=() instanceNames=()
sockfiles=( $(ls -1v ${DEFAULT_SOCKFILE}*) )
for sockfile in "${sockfiles[@]}"; do
	instanceName=${sockfile#$DEFAULT_SOCKFILE}
	: ${instanceName:=default}
	instanceNames+=( ${instanceName#.} )
done

selectedInstance=$TAILSCALE_INSTANCE
selectedSockfile=$DEFAULT_SOCKFILE

declare -a args=()
while [[ -n $1 ]]; do
	if [[ "$1" =~ ^-?-ins=? ]]; then
		if [[ "${1: -1}" == "=" ]]; then
			selectedInstance="${1#*=}"
		else
			shift
			selectedInstance="$1"
		fi
	else
		args+=( "$1" )
	fi
	shift
done

print_instances() {
	for instanceName in ${instanceNames[@]}; do
		echo "    - $instanceName" >&2
	done
}

if [[ ${#sockfiles[@]} -gt 1 ]]; then
	if [[ -z $selectedInstance ]]; then
		echo -ne "\x1b[33m" >&2
		echo     "There are multiple tailscale instances running:" >&2
		print_instances
		echo     "since you didn't make a selection, the 'default' instance is selected." >&2
		echo -ne "\x1b[0m" >&2
		echo -n  "You can specify it with the '--ins <name>' argument at any position," >&2
		echo     " or by the TAILSCALE_INSTANCE environment variable."$'\n' >&2
	else
		matched=
		for (( i=0; i<${#instanceNames[@]}; i++ )); do
			if [[ $selectedInstance == ${instanceNames[$i]} ]]; then
				selectedSockfile=${sockfiles[$i]}
				matched=1
				break
			fi
		done
		if [[ -z $matched ]]; then
			echo -ne "\x1b[33m" >&2
			echo     "The provided instance name '$selectedInstance' is invalid, available instances are:" >&2
			print_instances
			echo -ne "\x1b[0m" >&2
			exit 1
		fi
	fi
fi

set -- @EROOT@/usr/libexec/tailscale -socket="$selectedSockfile" "${args[@]}"
exec "$@"
