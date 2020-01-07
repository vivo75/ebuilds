# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_8,3_7} pypy3 )
PYTHON_REQ_USE='threads(+)'
inherit distutils-r1

DESCRIPTION="Stand-alone Manifest generation & verification tool"
HOMEPAGE="https://github.com/mgorny/gemato"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux"
IUSE="+blake2 bzip2 +gpg lzma sha3 test tools"
RESTRICT="!test? ( test )"

MODULE_RDEPEND="
	gpg? ( app-crypt/gnupg )"

RDEPEND="${MODULE_RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND=">=dev-python/setuptools-34[${PYTHON_USEDEP}]
	test? ( ${MODULE_RDEPEND} )"

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	if use tools; then
		exeinto /usr/share/gemato
		doexe utils/*.{bash,py}
	fi
}
