# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )
PYTHON_COMPAT=( python3_{8,9,10} )

inherit flag-o-matic linux-info lua-single perl-functions python-single-r1 strip-linguas toolchain-funcs

MY_PV_1="$(ver_cut 1-2)"
MY_PV_2="$(ver_cut 2)"
[[ $(( ${MY_PV_2} % 2 )) -eq 0 ]] && SD="stable" || SD="development"

DESCRIPTION="Tools for accessing, inspecting, and modifying virtual machine (VM) disk images"
HOMEPAGE="https://libguestfs.org/"
SRC_URI="https://libguestfs.org/download/${MY_PV_1}-${SD}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0/${MY_PV_1}"
# Unkeyworded for testing guestfs-tools split, #816693
#KEYWORDS="~amd64"
IUSE="doc erlang +fuse gtk inspect-icons introspection libvirt lua +ocaml +perl python ruby selinux static-libs systemtap test"
RESTRICT="!test? ( test )"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )"

# Failures - doc
# FIXME: selinux support is automagic
COMMON_DEPEND="
	>=app-admin/augeas-1.8.0
	app-arch/cpio
	app-arch/lzma
	app-arch/unzip[natspec]
	app-arch/xz-utils
	app-cdr/cdrtools
	app-crypt/gnupg
	>=app-emulation/qemu-2.0[qemu_softmmu_targets_x86_64,systemtap?,selinux?,filecaps]
	>=app-misc/hivex-1.3.1
	dev-lang/perl:=
	dev-libs/libconfig:=
	dev-libs/libpcre:3
	dev-libs/libxml2:2=
	dev-libs/jansson:=
	>=dev-libs/yajl-2.0.4
	net-libs/libtirpc:=
	sys-libs/ncurses:0=
	>=sys-apps/fakechroot-2.8
	sys-apps/fakeroot
	sys-apps/file
	sys-devel/gettext
	sys-fs/squashfs-tools:*
	>=sys-libs/db-4.6:*
	sys-libs/libcap
	sys-libs/readline:=
	virtual/acl
	virtual/libcrypt:=
	erlang? ( dev-lang/erlang )
	perl? (
		virtual/perl-ExtUtils-MakeMaker
		>=dev-perl/Sys-Virt-0.2.4
		virtual/perl-Getopt-Long
		virtual/perl-Data-Dumper
		dev-perl/libintl-perl
		>=app-misc/hivex-1.3.1[perl?]
		dev-perl/String-ShellQuote
	)
	python? ( ${PYTHON_DEPS} )
	fuse? ( sys-fs/fuse:= )
	gtk? (
		sys-apps/dbus
		x11-libs/gtk+:3
	)
	introspection? (
		>=dev-libs/glib-2.26:2
		>=dev-libs/gobject-introspection-1.30.0:=
	)
	inspect-icons? (
		media-libs/netpbm
		media-gfx/icoutils
	)
	libvirt? ( app-emulation/libvirt )
	lua? ( ${LUA_DEPS} )
	ocaml? ( >=dev-lang/ocaml-4.03:=[ocamlopt] )
	selinux? (
		sys-libs/libselinux
		sys-libs/libsemanage
	)
	systemtap? ( dev-util/systemtap )
"
# Some OCaml is always required
# bug #729674
DEPEND="${COMMON_DEPEND}
	>=dev-lang/ocaml-4.03:=[ocamlopt]
	dev-util/gperf
	dev-ml/findlib[ocamlopt]
	doc? ( app-text/po4a )
	ocaml? (
		dev-ml/ounit2[ocamlopt]
		|| (
			<dev-ml/ocaml-gettext-0.4.2
			dev-ml/ocaml-gettext-stub[ocamlopt]
		)
	)
	ruby? ( dev-lang/ruby virtual/rubygems dev-ruby/rake )
	test? ( introspection? ( dev-libs/gjs ) )
"
BDEPEND="virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	app-emulation/libguestfs-appliance
	acct-group/kvm
"
# Upstream build scripts compile and install Lua bindings for the ABI version
# obtained by running 'lua' on the build host
BDEPEND="lua? ( ${LUA_DEPS} )"

DOCS=( AUTHORS BUGS ChangeLog HACKING README TODO )

#PATCHES=(
#	"${FILESDIR}"/${MY_PV_1}/
#)

pkg_setup() {
	CONFIG_CHECK="~KVM ~VIRTIO"
	[[ -n "${CONFIG_CHECK}" ]] && check_extra_config

	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_configure() {
	# bug #794877
	tc-export AR

	# Skip Bash test
	# (See 13-test-suite.log in linked bug)
	# bug #794874
	export SKIP_TEST_COMPLETE_IN_SCRIPT_SH=1

	# Disable feature test for kvm for more reason
	# i.e: not loaded module in __build__ time,
	# build server not supported kvm, etc. ...
	#
	# In fact, this feature is virtio support and requires
	# configured kernel.
	export vmchannel_test=no

	# Give a nudge to help find libxcrypt[-system]
	# We have a := dep on virtual/libcrypt to ensure this doesn't become stale.
	# bug #703118, bug #789354
	if ! has_version 'sys-libs/libxcrypt[system]' ; then
		append-ldflags "-L${ESYSROOT}/usr/$(get_libdir)/xcrypt"
		append-ldflags "-Wl,-R${ESYSROOT}/usr/$(get_libdir)/xcrypt"
	fi

	econf \
		--disable-appliance \
		--disable-daemon \
		--disable-haskell \
		--disable-golang \
		--disable-rust \
		--disable-php \
		--without-java \
		--with-extra="-gentoo" \
		--with-readline \
		$(usex doc '' PO4A=no) \
		$(use_enable ocaml) \
		$(use_enable erlang) \
		$(use_enable fuse) \
		$(use_enable introspection gobject) \
		$(use_enable introspection) \
		$(use_with libvirt) \
		$(use_enable lua) \
		$(use_enable python) \
		$(use_enable perl) \
		$(use_enable ruby) \
		$(use_enable static-libs static) \
		$(use_enable systemtap probes)
}

src_install() {
	strip-linguas -i po

	emake DESTDIR="${D}" install "LINGUAS=""${LINGUAS}"""

	find "${ED}" -name '*.la' -delete || die

	if use perl ; then
		perl_delete_localpod

		# Workaround Build.PL for now
		doman "${ED}"/usr/man/man3/Sys::Guestfs.3pm
		rm -rf "${ED}"/usr/man || die
	fi
}

pkg_preinst() {
	local libguestfs_depstring="<app-emulation/libguestfs-1.46.0-r1"

	# Did we have a version of libguestfs before the split into guestfs-tools?
	# (libguestfs used to install the tools too)
	if has_version "${libguestfs_depstring}[ocaml]" || has_version "${libguestfs_depstring}[perl]" ; then
		HAD_LIBGUESTFS_WITH_TOOLS=1
	fi
}

pkg_postinst() {
	einfo "Please ensure you are in the 'kvm' group for decent performance!"

	if ! use gtk ; then
		einfo "virt-p2v NOT installed"
	fi

	if [[ ${HAD_LIBGUESTFS_WITH_TOOLS} -eq 1 ]] ; then
		ewarn "libguestfs' tools are now packaged as app-emulation/guestfs-tools from 1.46.0 onwards!"
	fi
}