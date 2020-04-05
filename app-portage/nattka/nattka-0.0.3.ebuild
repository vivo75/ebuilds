# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python{3_8,3_7} )

inherit distutils-r1

DESCRIPTION="A New Arch Tester Toolkit -- open-source stable-bot replacement"
HOMEPAGE="https://github.com/mgorny/nattka/"
SRC_URI="https://github.com/mgorny/nattka/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-util/pkgcheck[${PYTHON_USEDEP}]
	dev-vcs/git
	sys-apps/pkgcore[${PYTHON_USEDEP}]"
BDEPEND="
	test? ( dev-python/vcrpy[${PYTHON_USEDEP}] )"

distutils_enable_sphinx doc --no-autodoc
distutils_enable_tests pytest
