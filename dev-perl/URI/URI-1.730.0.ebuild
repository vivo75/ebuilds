# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=1.73
inherit perl-module

DESCRIPTION="Uniform Resource Identifiers (absolute and relative)"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Encode
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-File-Spec
	>=virtual/perl-MIME-Base64-2
	virtual/perl-Scalar-List-Utils
	virtual/perl-libnet
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.960.0
	)
"
