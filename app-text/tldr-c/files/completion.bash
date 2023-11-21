#!/bin/bash

PLATFORM_TYPES="linux osx sunos windows"

OPTIONS='-v
--version
-l
--list
-r
--render
-p
--platform
--linux
--osx
--sunos
-u
--update
-c
--clear-cache
-h
--help'

function _tldr_autocomplete {
  OPTS_NOT_USED=$( comm -23 <( echo "$OPTIONS" | sort ) <( printf '%s\n' "${COMP_WORDS[@]}" | sort ) )

  cur="${COMP_WORDS[$COMP_CWORD]}"
  COMPREPLY=()
  if [[ "$cur" =~ ^-.* ]]
  then
    COMPREPLY=(`compgen -W "$OPTS_NOT_USED" -- $cur`)
  else
    if [[ $COMP_CWORD -eq 0 ]]
    then
      prev=""
    else
      prev=${COMP_WORDS[$COMP_CWORD-1]}
    fi
    case "$prev" in
      -r|--render)
        COMPREPLY=(`compgen -f $cur`)
        ;;
      -p|--platform)
        COMPREPLY=(`compgen -W "$PLATFORM_TYPES" $cur`)
        ;;
      *)
        sheets=$(env TLDR_AUTO_UPDATE_DISABLED=1 tldr --list)
        COMPREPLY=(`compgen -W "$sheets $OPTS_NOT_USED" -- $cur`)
        ;;
    esac
  fi
}

complete -F _tldr_autocomplete tldr
