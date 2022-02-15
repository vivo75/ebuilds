# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature

DESCRIPTION="Python library for loading and using triangular meshes"
HOMEPAGE="https://trimsh.org/ https://github.com/mikedh/trimesh"
# No tests in PyPI tarballs
SRC_URI="https://github.com/mikedh/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

# Almost 70 tests require rtree, which is currently unpackaged
RESTRICT="test"

RDEPEND="dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/colorlog[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pycollada[${PYTHON_USEDEP}]
	dev-python/pyglet[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/svg-path[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	dev-python/xxhash[${PYTHON_USEDEP}]
	sci-libs/shapely[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

pkg_postinst() {
	optfeature_header "${PN} functionality can be extended by installing the following packages:"
	optfeature "making GUI applications with 3D stuff" dev-python/glooey
	optfeature "figuring out how much memory we have" dev-python/psutil
	optfeature "marching cubes and other nice stuff" sci-libs/scikit-image
}