# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_8,3_7} pypy3 )

inherit distutils-r1

MY_PN=${PN//-/_}

DESCRIPTION="WebSocket client for python with hybi13 support"
HOMEPAGE="https://github.com/websocket-client/websocket-client"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~x64-macos"
IUSE="examples test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	test? ( ${RDEPEND} )
"

S="${WORKDIR}/${MY_PN}-${PV}"

distutils_enable_tests setup.py

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
