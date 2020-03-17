# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_8,3_7} )
inherit distutils-r1

DESCRIPTION="A small 'shelve' like datastore with concurrency support"
HOMEPAGE="https://github.com/pickleshare/pickleshare"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/path-py-6.2[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	py.test || die
}
