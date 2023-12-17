# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Empty package for macOS: dev-vcs/git"
HOMEPAGE="https://www.git-scm.com/"

LICENSE="GPL-2"
SLOT="empty-pkg"
KEYWORDS="-* ~arm64-macos"

S="$WORKDIR"

src_install() {
	if [[ -x /usr/bin/git ]]; then
		/usr/bin/git --version &>/dev/null || die
	fi
}
