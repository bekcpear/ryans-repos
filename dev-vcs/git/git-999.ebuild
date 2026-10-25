# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Empty package for macOS: dev-vcs/git"
HOMEPAGE="https://git-scm.com/"

S="$WORKDIR"

LICENSE="GPL-2"
SLOT="empty-pkg"
KEYWORDS="-* ~arm64-macos"
# git-r3 BDEPENDs on dev-vcs/git[curl]; the macOS system git always supports https
IUSE="+curl"

src_install() {
	if [[ -x /usr/bin/git ]]; then
		/usr/bin/git --version &>/dev/null || die
	fi
}
