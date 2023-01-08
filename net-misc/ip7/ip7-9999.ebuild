# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 go systemd

DESCRIPTION="An IP address checker, powered by MaxMind GeoLite2 databases."
HOMEPAGE="https://github.com/bekcpear/ip7"
EGIT_REPO_URI="https://gitlab.com/cwittlut/ip7.git"

LICENSE="Apache-2.0 BSD GPL-2 ISC"
SLOT="0"

RDEPEND="acct-user/ip7"
BDEPEND=">=dev-lang/go-1.19:="

src_unpack() {
	git-r3_src_unpack
	go_setup_vendor
}

src_install() {
	go_src_install

	insinto /etc/ip7
	doins configs/config.json

	# the configuration file may contain the license key, so chmod to 600
	fowners -R ip7:ip7 /etc/ip7
	fperms 600 /etc/ip7/config.json

	newinitd configs/ip7.initd ip7
	newconfd configs/ip7.confd ip7

	systemd_dounit configs/ip7.service
}
