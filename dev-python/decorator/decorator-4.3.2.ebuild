# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_8,3_7} pypy3 )

inherit distutils-r1

DESCRIPTION="Simplifies the usage of decorators for the average programmer"
HOMEPAGE="https://github.com/micheles/decorator https://pypi.org/project/decorator/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( README.rst )

python_test() {
	"${PYTHON}" src/tests/test.py || die "Tests fail with ${EPYTHON}"
}
