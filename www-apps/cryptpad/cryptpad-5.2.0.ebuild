# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Collaboration suite, end-to-end encrypted and open-source."
HOMEPAGE="https://github.com/xwiki-labs/cryptpad"
SRC_URI="https://github.com/xwiki-labs/cryptpad/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/bekcpear/cryptpad-release/archive/refs/tags/${PV}.tar.gz -> ${PN}-release-${PV}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND=""
RDEPEND="${DEPEND}
	>=net-libs/nodejs-12.14.0
	acct-user/cryptpad
	acct-group/cryptpad"
BDEPEND=""

src_prepare() {
	mv "${WORKDIR}"/${PN}-release-${PV}/node_modules "${S}" || die
	mv "${WORKDIR}"/${PN}-release-${PV}/www/bower_components "${S}"/www/ || die

	cp "${FILESDIR}"/cryptpad.{service,initd} ./ || die
	eapply_user
}

src_install () {
	local install_dir="/usr/$(get_libdir)/node_modules/${PN}" path shebang
	eval "sed -Ei 's#@PATH@#${install_dir}#' cryptpad.{service,initd}" || die

	insinto ${install_dir}
	doins -r .

	insinto /etc/cryptpad
	newins config/config.example.js config.js
	dosym -r /etc/cryptpad/config.js ${install_dir}/config/config.js

	keepdir /var/lib/cryptpad/{blob,block,customize,data,datastore}
	fowners cryptpad:cryptpad /var/lib/cryptpad/{blob,block,customize,data,datastore}
	dosym -r /var/lib/cryptpad/blob ${install_dir}/blob
	dosym -r /var/lib/cryptpad/block ${install_dir}/block
	dosym -r /var/lib/cryptpad/customize ${install_dir}/customize
	dosym -r /var/lib/cryptpad/data ${install_dir}/data
	dosym -r /var/lib/cryptpad/datastore ${install_dir}/datastore

	keepdir /var/log/cryptpad
	fowners cryptpad:cryptpad /var/log/cryptpad

	newconfd "${FILESDIR}/cryptpad.confd" cryptpad
	newinitd "cryptpad.initd" cryptpad
	systemd_dounit "cryptpad.service"
}
