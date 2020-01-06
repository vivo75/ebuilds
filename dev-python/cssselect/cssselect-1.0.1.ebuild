# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_8,3_7} )

inherit distutils-r1

DESCRIPTION="parses CSS3 Selectors and translates them to XPath 1.0"
HOMEPAGE="https://cssselect.readthedocs.io/en/latest/
	https://pypi.org/project/cssselect/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc test"

# No tests.py file in this release.
# Please check on version bumps if it's still missing.
RESTRICT="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/lxml[${PYTHON_USEDEP}] )"

RDEPEND=""

python_prepare_all() {
	# prevent non essential d'load of files in doc build
	sed -e 's:intersphinx_:#&:' -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc ; then
		"${PYTHON}" setup.py build_sphinx || die
	fi
}

python_test() {
	"${PYTHON}" ${PN}/tests.py -v || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
