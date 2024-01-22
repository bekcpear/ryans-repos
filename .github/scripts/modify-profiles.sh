#!/bin/bash
#

APPEND_DIR="$(realpath "$1")"
GENTOO_DIR="$(realpath "$2")"
typeset -p APPEND_DIR GENTOO_DIR

files=()
while IFS='' read -r line; do
  files+=( "${line#"${APPEND_DIR%/}/"}" )
done < <(find "$APPEND_DIR" -type f)

for file in "${files[@]}"; do
	echo -e "\x1b[1;32m>>>\x1b[0m" cat "${APPEND_DIR%/}/${file} >>${GENTOO_DIR%/}/${file} || true" >&2
	cat "${APPEND_DIR%/}/${file}" >>"${GENTOO_DIR%/}/${file}" || true
done
