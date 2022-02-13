# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=33693a928986006d79c1ee743733cde5966ac402
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt5 plugin metadata dumper"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/qtplugininfo
)
