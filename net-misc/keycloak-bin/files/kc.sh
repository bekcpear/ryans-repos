#!/usr/bin/env bash
#
env_file="@EROOT@/etc/keycloak/runtime.env"
if [[ -r $env_file ]]; then
  while read -r line; do
    if [[ ${line} =~ ^[[:space:]]*export[[:space:]]+[[:alpha:]_][[:alnum:]_]*= ]]; then
      eval "$line"
    elif [[ ${line} =~ ^[[:space:]]*[[:alpha:]_][[:alnum:]_]*= ]]; then
      eval "export $line"
    fi
  done <"$env_file"
fi
eval exec @EROOT@/opt/keycloak-bin/bin/kc.sh "$@"
