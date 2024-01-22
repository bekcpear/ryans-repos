#!/bin/bash
#

IN="$(realpath "$1")"
OUT="$(realpath "$2")"
GENTOO_COMMIT="$3"
DATETIME="$4"
PKGCHECK_VERSION="$5"
WORKFLOW_RUN="$6"

declare level name category package eclass version desc isEclass
declare -i errorsCount=0 warningsCount=0

parseHeader() {
  printf '*Scan datetime: %s*\n' "${DATETIME:-N/A}"
  printf '*Pkgcheck version: %s*\n' "${PKGCHECK_VERSION:-N/A}"
  printf '*The newest `::gentoo` commit: https://github.com/gentoo-mirror/gentoo/commit/%s*\n' "${GENTOO_COMMIT:-N/A}"
  printf '*The corresponding workflow run: %s*\n\n' "${WORKFLOW_RUN:-N/A}"

  printf '|Summary|\n'
  printf '|:-:|\n'
  printf '|Errors count: **@@errorsCount@@**|\n'
  printf '|Warnings count: **@@warningsCount@@**|\n\n'

  printf '<details open><summary>Details:</summary>\n\n'
  printf '|Level|Keyword|Category|File|Message|\n'
  printf '|:----|:------|:-------|:---|:------|\n'
}
parsePost() {
  local mark=""
  if (( errorsCount > 0 )); then
    mark=" :bangbang:"
  fi
  sed -Ei "1,10s/@@errorsCount@@/${errorsCount}${mark}/" "$OUT"
  sed -Ei "1,10s/@@warningsCount@@/${warningsCount}/" "$OUT"
  printf '\n</details>\n' >>"$OUT"
}

parse() {

  if [[ $level == "error" ]]; then
    printf '|:x: %s|' "$level"
    (( errorsCount++ ))
  elif [[ $level == "warning" ]]; then
    printf '|:warning: %s|' "$level"
    (( warningsCount++ ))
  else
    printf '|%s|' "$level"
  fi

  printf '%s|' "$name"

  if (( isEclass == 1 )); then
    printf 'Eclass|'
    printf '%s.eclass|' "$eclass"
  else
    printf '%s|' "$category"
    printf '%s-%s.ebuild|' "$package" "$version"
  fi

  printf '%s|\n' "${desc//|/\\|}"
}

main() {
  # format {level},{name},{category},{package},{eclass},{version},{desc}
  while IFS="," read -r level name category package eclass version desc; do
    if [[ -z $category ]] && [[ -z $package ]]; then
      isEclass=1
    else
      isEclass=0
    fi
    parse >>"$OUT"
  done <"$IN"
}
parseHeader >"$OUT"
main
parsePost
