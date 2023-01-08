# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the HTTP API service of net-misc/ip7"
ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/ip7
ACCT_USER_GROUPS=( ip7 )

acct-user_add_deps
