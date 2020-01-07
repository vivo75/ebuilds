# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_8,3_7} pypy3 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Unittest extension with automatic test suite discovery and easy test authoring"
HOMEPAGE="
	https://pypi.org/project/nose/
	https://nose.readthedocs.io/en/latest/
	https://github.com/nose-devs/nose"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-python-3.5-backport.patch )

python_prepare_all() {
	# Disable tests requiring network connection.
	sed \
		-e "s/test_resolve/_&/g" \
		-e "s/test_raises_bad_return/_&/g" \
		-e "s/test_raises_twisted_error/_&/g" \
		-i unit_tests/test_twisted.py || die "sed failed"
	# Disable versioning of nosetests script to avoid collision with
	# versioning performed by the eclass.
	sed -e "/'nosetests%s = nose:run_exit' % py_vers_tag,/d" \
		-i setup.py || die "sed2 failed"

	# Prevent un-needed d'loading during doc build
	sed -e "s/, 'sphinx.ext.intersphinx'//" -i doc/conf.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	local add_targets=()

	distutils-r1_python_compile ${add_targets[@]}
}

python_install() {
	distutils-r1_python_install --install-data "${EPREFIX}/usr/share"
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
