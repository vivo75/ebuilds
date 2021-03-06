# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_7 python3_8 python3_9 )

inherit autotools multilib multilib-minimal toolchain-funcs preserve-libs python-r1 linux-info systemd usr-ldscript

DESCRIPTION="Userspace utilities for storing and processing auditing records"
HOMEPAGE="https://people.redhat.com/sgrubb/audit/"
# https://github.com/linux-audit/audit-userspace/tree/2.8_maintenance
COMMIT='80866dc78b5db17010516e24344eaed8dcc6fb99' # contains many fixes not yet released
if [[ -n $COMMIT ]]; then
	SRC_URI="https://github.com/linux-audit/audit-userspace/archive/${COMMIT}.tar.gz -> ${P}_p${COMMIT:0:12}.tar.gz"
	S="${WORKDIR}/audit-userspace-${COMMIT}"
else
	SRC_URI="https://people.redhat.com/sgrubb/audit/${P}.tar.gz"
fi
# -fno-common patch:
SRC_URI+=" https://github.com/linux-audit/audit-userspace/commit/017e6c6ab95df55f34e339d2139def83e5dada1f.patch -> ${PN}-017e6c6ab95df55f34e339d2139def83e5dada1f.patch"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="gssapi ldap python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
# Testcases are pretty useless as they are built for RedHat users/groups and kernels.
RESTRICT="test"

RDEPEND="gssapi? ( virtual/krb5 )
	ldap? ( net-nds/openldap )
	sys-libs/libcap-ng
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.34
	python? ( dev-lang/swig:0 )"
# Do not use os-headers as this is linux specific

CONFIG_CHECK="~AUDIT"

pkg_setup() {
	linux-info_pkg_setup
}

src_prepare() {
	# Do not build GUI tools
	sed -i \
		-e '/AC_CONFIG_SUBDIRS.*system-config-audit/d' \
		"${S}"/configure.ac || die
	sed -i \
		-e 's,system-config-audit,,g' \
		"${S}"/Makefile.am || die
	rm -rf "${S}"/system-config-audit

	# audisp-remote moved in multilib_src_install_all
	sed -i \
		-e "s,/sbin/audisp-remote,${EPREFIX}/usr/sbin/audisp-remote," \
		"${S}"/audisp/plugins/remote/au-remote.conf || die

	# Don't build static version of Python module.
	eapply "${FILESDIR}"/${PN}-2.4.3-python.patch

	# glibc/kernel upstreams suck with both defining ia64_fpreg
	# This patch is a horribly workaround that is only valid as long as you
	# don't need the OTHER definitions in fpu.h.
	eapply "${FILESDIR}"/${PN}-2.8.4-ia64-compile-fix.patch

	# there is no --without-golang conf option
	sed -e "/^SUBDIRS =/s/ @gobind_dir@//" -i bindings/Makefile.am || die

	# -fno-common
	eapply "${DISTDIR}/${PN}-017e6c6ab95df55f34e339d2139def83e5dada1f.patch"

	eapply_user

	# Regenerate autotooling
	eautoreconf
}

multilib_src_configure() {
	local ECONF_SOURCE=${S}
	local my_conf="$(use_enable ldap zos-remote)"
	econf \
		${my_conf} \
		--sbindir="${EPREFIX}/sbin" \
		$(use_enable gssapi gssapi-krb5) \
		$(use_enable static-libs static) \
		--enable-systemd \
		--without-python \
		--without-python3

	if multilib_is_native_abi; then
		python_configure() {
			mkdir -p "${BUILD_DIR}" || die
			cd "${BUILD_DIR}" || die

			econf ${my_conf} --without-python --with-python3
		}

		use python && python_foreach_impl python_configure
	fi
}

src_configure() {
	tc-export_build_env BUILD_{CC,CPP}
	export CC_FOR_BUILD="${BUILD_CC}"
	export CPP_FOR_BUILD="${BUILD_CPP}"

	multilib-minimal_src_configure
}

multilib_src_compile() {
	if multilib_is_native_abi; then
		default

		python_compile() {
			emake -C "${BUILD_DIR}"/bindings/swig \
				VPATH="${native_build}/lib" \
				LIBS="${native_build}/lib/libaudit.la" \
				_audit_la_LIBADD="${native_build}/lib/libaudit.la" \
				_audit_la_DEPENDENCIES="${S}/lib/libaudit.h ${native_build}/lib/libaudit.la" \
				USE_PYTHON3=true
			emake -C "${BUILD_DIR}"/bindings/python/python3 \
				VPATH="${S}/bindings/python/python3:${native_build}/bindings/python/python3" \
				auparse_la_LIBADD="${native_build}/auparse/libauparse.la ${native_build}/lib/libaudit.la" \
				USE_PYTHON3=true
		}

		local native_build="${BUILD_DIR}"
		use python && python_foreach_impl python_compile
	else
		emake -C lib
		emake -C auparse
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		emake DESTDIR="${D}" initdir="$(systemd_get_systemunitdir)" install

		python_install() {
			emake -C "${BUILD_DIR}"/bindings/swig \
				VPATH="${native_build}/lib" \
				LIBS="${native_build}/lib/libaudit.la" \
				_audit_la_LIBADD="${native_build}/lib/libaudit.la" \
				_audit_la_DEPENDENCIES="${S}/lib/libaudit.h ${native_build}/lib/libaudit.la" \
				USE_PYTHON3=true \
				DESTDIR="${D}" install
			emake -C "${BUILD_DIR}"/bindings/python/python3 \
				VPATH="${S}/bindings/python/python3:${native_build}/bindings/python/python3" \
				auparse_la_LIBADD="${native_build}/auparse/libauparse.la ${native_build}/lib/libaudit.la" \
				USE_PYTHON3=true \
				DESTDIR="${D}" install
			python_optimize
		}

		local native_build=${BUILD_DIR}
		use python && python_foreach_impl python_install

		# things like shadow use this so we need to be in /
		gen_usr_ldscript -a audit auparse
	else
		emake -C lib DESTDIR="${D}" install
		emake -C auparse DESTDIR="${D}" install
	fi
}

multilib_src_install_all() {
	dodoc AUTHORS ChangeLog README* THANKS
	docinto contrib
	dodoc contrib/{avc_snap,skeleton.c}
	docinto contrib/plugin
	dodoc contrib/plugin/*
	docinto rules
	dodoc rules/*

	newinitd "${FILESDIR}"/auditd-init.d-2.4.3 auditd
	newconfd "${FILESDIR}"/auditd-conf.d-2.1.3 auditd

	[ -f "${ED}"/sbin/audisp-remote ] && \
	dodir /usr/sbin && \
	mv "${ED}"/{sbin,usr/sbin}/audisp-remote || die

	# Gentoo rules
	insinto /etc/audit/
	newins "${FILESDIR}"/audit.rules-2.1.3 audit.rules
	doins "${FILESDIR}"/audit.rules.stop*

	# audit logs go here
	keepdir /var/log/audit/

	find "${D}" -name '*.la' -delete || die

	# Security
	lockdown_perms "${ED}"
}

pkg_preinst() {
	# Preserve from the audit-1 series
	preserve_old_lib /$(get_libdir)/libaudit.so.0
}

pkg_postinst() {
	lockdown_perms "${EROOT}"
	# Preserve from the audit-1 series
	preserve_old_lib_notify /$(get_libdir)/libaudit.so.0
}

lockdown_perms() {
	# Upstream wants these to have restrictive perms.
	# Should not || die as not all paths may exist.
	local basedir="$1"
	chmod 0750 "${basedir}"/sbin/au{ditctl,report,dispd,ditd,search,trace} 2>/dev/null
	chmod 0750 "${basedir}"/var/log/audit/ 2>/dev/null
	chmod 0640 "${basedir}"/etc/{audit/,}{auditd.conf,audit.rules*} 2>/dev/null
}
