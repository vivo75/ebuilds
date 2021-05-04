# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Small utility library that handles metadata minification and expansion"
HOMEPAGE="https://github.com/composer/metadata-minifier"
SRC_URI="https://github.com/composer/metadata-minifier/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-php/theseer-Autoload"

RDEPEND="dev-php/fedora-autoloader
	>=dev-lang/php-7.2:*"

src_prepare() {
	default

	phpab \
		--output src/autoload.php \
		--template fedora2 \
		--basedir src \
		src \
		|| die
}

src_install() {
	insinto '/usr/share/php/Composer/MetadataMinifier'
	doins -r src/*

	einstalldocs
}