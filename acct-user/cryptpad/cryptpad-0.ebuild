# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the www-apps/cryptpad service"
ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/cryptpad
ACCT_USER_GROUPS=( cryptpad )

acct-user_add_deps
