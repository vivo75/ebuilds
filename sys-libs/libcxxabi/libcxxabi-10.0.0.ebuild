# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_8,3_7} )
inherit cmake-multilib llvm llvm.org multiprocessing python-any-r1 toolchain-funcs

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="https://libcxxabi.llvm.org/"
# libcxx is needed uncondtionally for the headers
LLVM_COMPONENTS=( libcxx{abi,} )
llvm.org_set_globals

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="+libunwind +static-libs test elibc_musl"
RESTRICT="!test? ( test )"

RDEPEND="
	libunwind? (
		|| (
			>=sys-libs/libunwind-1.0.1-r1[static-libs?,${MULTILIB_USEDEP}]
			>=sys-libs/llvm-libunwind-3.9.0-r1[static-libs?,${MULTILIB_USEDEP}]
		)
	)"
# llvm-6 for new lit options
DEPEND="${RDEPEND}
	>=sys-devel/llvm-6"
BDEPEND="
	test? ( >=sys-devel/clang-3.9.0
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]') )"

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

multilib_src_configure() {
	# link against compiler-rt instead of libgcc if we are using clang with libunwind
	local want_compiler_rt=OFF
	if use libunwind && tc-is-clang; then
		local compiler_rt=$($(tc-getCC) ${CFLAGS} ${CPPFLAGS} \
			${LDFLAGS} -print-libgcc-file-name)
		if [[ ${compiler_rt} == *libclang_rt* ]]; then
			want_compiler_rt=ON
		fi
	fi

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLIBCXXABI_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_ENABLE_SHARED=ON
		-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)
		-DLIBCXXABI_INCLUDE_TESTS=$(usex test)
		-DLIBCXXABI_USE_COMPILER_RT=${want_compiler_rt}

		-DLIBCXXABI_LIBCXX_INCLUDES="${WORKDIR}"/libcxx/include
		# upstream is omitting standard search path for this
		# probably because gcc & clang are bundling their own unwind.h
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${EPREFIX}"/usr/include
	)
	if use test; then
		local clang_path=$(type -P "${CHOST:+${CHOST}-}clang" 2>/dev/null)
		local jobs=${LIT_JOBS:-$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")}

		[[ -n ${clang_path} ]] || die "Unable to find ${CHOST}-clang for tests"

		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="-vv;-j;${jobs};--param=cxx_under_test=${clang_path}"
		)
	fi
	cmake-utils_src_configure
}

build_libcxx() {
	local -x LDFLAGS="${LDFLAGS} -L${BUILD_DIR}/$(get_libdir)"
	local CMAKE_USE_DIR=${WORKDIR}/libcxx
	local BUILD_DIR=${BUILD_DIR}/libcxx
	local mycmakeargs=(
		-DLIBCXX_LIBDIR_SUFFIX=
		-DLIBCXX_ENABLE_SHARED=OFF
		-DLIBCXX_ENABLE_STATIC=ON
		-DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=OFF
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_CXX_ABI_INCLUDE_PATHS="${S}"/include
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=OFF
		-DLIBCXX_HAS_MUSL_LIBC=$(usex elibc_musl)
		-DLIBCXX_HAS_GCC_S_LIB=OFF
		-DLIBCXX_INCLUDE_TESTS=OFF
	)

	cmake-utils_src_configure
	cmake-utils_src_compile
}

multilib_src_test() {
	# build a local copy of libc++ for testing to avoid circular dep
	build_libcxx
	mv "${BUILD_DIR}"/libcxx/lib/libc++* "${BUILD_DIR}/$(get_libdir)/" || die

	local -x LIT_PRESERVES_TMP=1
	cmake-utils_src_make check-libcxxabi
}

multilib_src_install_all() {
	insinto /usr/include/libcxxabi
	doins -r include/.
}
