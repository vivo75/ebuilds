# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="../CHANGELOG.md ../MIGRATING.md ../README.md ../UPGRADING.md"

GITHUB_USER="aws"
GITHUB_PROJECT="${PN}-ruby"
RUBY_S="${GITHUB_PROJECT}-${PV}/${PN}"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Official SDK for Amazon Web Services"
HOMEPAGE="https://aws.amazon.com/sdkforruby"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/archive/v${PV}.tar.gz -> ${GITHUB_PROJECT}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm64"
IUSE=""

ruby_add_rdepend "virtual/ruby-ssl
	~dev-ruby/aws-sdk-resources-${PV}"
