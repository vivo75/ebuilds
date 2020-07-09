# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_8,3_7} pypy3 )

inherit distutils-r1

DESCRIPTION="pyasn1 modules"
HOMEPAGE="http://snmplabs.com/pyasn1/ https://github.com/etingof/pyasn1-modules/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/pyasn1-0.4.6[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

distutils_enable_tests setup.py

python_install_all() {
	distutils-r1_python_install_all
	insinto /usr/share/${P}
	doins -r tools
}
