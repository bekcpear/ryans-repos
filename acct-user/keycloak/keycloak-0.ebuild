# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the keycloak daemon"
ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/keycloak
ACCT_USER_HOME_PERMS=0750
ACCT_USER_GROUPS=( keycloak )

acct-user_add_deps
