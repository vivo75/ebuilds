# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_7 python3_8 python3_9 )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="g-sorcery backend for elisp packages"
HOMEPAGE="https://github.com/jauhien/gs-elpa"
SRC_URI="https://github.com/jauhien/gs-elpa/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="app-portage/g-sorcery[$(python_gen_usedep 'python*')]
	dev-python/sexpdata[$(python_gen_usedep 'python*')]"
RDEPEND="${DEPEND}"

python_install_all() {
	distutils-r1_python_install_all
	doman docs/*.8
}
