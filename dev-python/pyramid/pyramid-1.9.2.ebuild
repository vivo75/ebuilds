# Copyright 1999-2017 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A small open source Python web framework"
HOMEPAGE="http://www.pylonsproject.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/chameleon[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/webob[${PYTHON_USEDEP}]
	dev-python/repoze-lru[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/zope-deprecation[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	dev-python/translationstring[${PYTHON_USEDEP}]
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	dev-python/venusian[${PYTHON_USEDEP}]
	dev-python/plaster[${PYTHON_USEDEP}]"

