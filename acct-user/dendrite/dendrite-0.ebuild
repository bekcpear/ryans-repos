# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the net-im/dendrite service"
ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/dendrite
ACCT_USER_GROUPS=( dendrite )

acct-user_add_deps
