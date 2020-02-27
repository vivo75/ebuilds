# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit distutils-r1

DESCRIPTION="A pure Python chess library"
HOMEPAGE="http://pychess.org/"
SRC_URI="https://github.com/niklasf/python-chess/archive/v0.30.1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/elementtree[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

