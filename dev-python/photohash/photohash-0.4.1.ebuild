# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Photohash"
MY_P=${MY_PN}-${PV}
S="${WORKDIR}"/${MY_P}
PYTHON_COMPAT=( python{3_8,3_7} )

inherit distutils-r1

DESCRIPTION="Python bindings for SDL multimedia library"
HOMEPAGE="http://www.pygame.org/"
SRC_URI="mirror://pypi/P/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/pillow[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

# various module import and data path issues
RESTRICT=test

