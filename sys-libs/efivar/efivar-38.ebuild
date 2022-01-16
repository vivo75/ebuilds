# Copyright 2014-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tools and library to manipulate EFI variables"
HOMEPAGE="https://github.com/rhinstaller/efivar"
SRC_URI="https://github.com/rhinstaller/efivar/releases/download/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-text/mandoc
	test? ( sys-boot/grub:2 )
"
RDEPEND="
	dev-libs/popt
"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-3.18
	virtual/pkgconfig
"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-38-ia64-relro.patch
	)
	default
}

src_configure() {
	tc-export CC
	export CC_FOR_BUILD=$(tc-getBUILD_CC)

	tc-ld-disable-gold

	export libdir="/usr/$(get_libdir)"

	# https://bugs.gentoo.org/562004
	unset LIBS

	# Avoid -Werror
	export ERRORS=

	if [[ -n ${GCC_SPECS} ]]; then
		# The environment overrides the command line.
		GCC_SPECS+=":${S}/src/include/gcc.specs"
	fi

	# Used by tests/Makefile
	export GRUB_PREFIX=grub
}
