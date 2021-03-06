# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_8 python3_7 python3_9 )

inherit distutils-r1

DESCRIPTION="SQLAlchemy integration with the marshmallow (de)serialization library"
HOMEPAGE="https://github.com/marshmallow-code/marshmallow-sqlalchemy/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/marshmallow[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/simplejson[${PYTHON_USEDEP}]
	)"

src_prepare() {
	distutils-r1_src_prepare
}

python_test() {
	py.test -v || die "tests failed under ${EPYTHON}"
}
