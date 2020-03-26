# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_8,3_7} )
inherit distutils-r1

DESCRIPTION="Pure Python SSH tunnels"
HOMEPAGE="https://pypi.python.org/pypi/sshtunnel"
SRC_URI="mirror://pypi/s/sshtunnel/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86"
LICENSE="MIT"
SLOT="0"

IUSE="test"

RDEPEND="dev-python/paramiko[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/tox[${PYTHON_USEDEP}] )
"

distutils_enable_tests setup.py
