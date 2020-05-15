# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_8,3_7} )
inherit distutils-r1

DESCRIPTION="A more Pythonic version of doxypy, a Doxygen filter for Python"
HOMEPAGE="https://pypi.org/project/doxypypy/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
