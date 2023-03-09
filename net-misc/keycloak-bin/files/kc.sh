#!/usr/bin/env bash
#
env_file="@EROOT@/etc/keycloak/runtime.env"
[[ ! -r $env_file ]] || . "$env_file"
eval exec @EROOT@/opt/keycloak-bin/bin/kc.sh "$@"
