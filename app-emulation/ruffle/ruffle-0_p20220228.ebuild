# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	adler32-1.2.0
	ahash-0.7.6
	aho-corasick-0.7.18
	alsa-0.6.0
	alsa-sys-0.3.1
	ansi_term-0.12.1
	approx-0.5.1
	arrayvec-0.5.2
	arrayvec-0.7.2
	ash-0.34.0+1.2.203
	ashpd-0.2.2
	async-broadcast-0.3.4
	async-channel-1.6.1
	async-executor-1.4.1
	async-io-1.6.0
	async-lock-2.5.0
	async-recursion-0.3.2
	async-task-4.1.0
	async-trait-0.1.52
	atk-sys-0.15.1
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	bindgen-0.56.0
	bit-set-0.5.2
	bit-vec-0.6.3
	bitflags-1.3.2
	bitflags_serde_shim-0.2.2
	bitstream-io-1.2.0
	bitvec-0.19.6
	block-0.1.6
	block-buffer-0.10.2
	bstr-0.2.17
	build_const-0.2.2
	bumpalo-3.9.1
	bytemuck-1.7.3
	bytemuck_derive-1.0.1
	byteorder-1.4.3
	bytes-1.1.0
	cache-padded-1.2.0
	cairo-sys-rs-0.15.1
	calloop-0.9.3
	castaway-0.1.2
	cc-1.0.73
	cesu8-1.1.0
	cexpr-0.4.0
	cfg-expr-0.10.1
	cfg-if-0.1.10
	cfg-if-1.0.0
	cfg_aliases-0.1.1
	chrono-0.4.19
	clang-sys-1.3.1
	clap-3.1.2
	clap_derive-3.1.2
	clipboard-0.5.0
	clipboard-win-2.2.0
	cocoa-0.24.0
	cocoa-foundation-0.1.0
	codespan-reporting-0.11.1
	color_quant-1.1.0
	combine-4.6.3
	concurrent-queue-1.2.2
	console-0.15.0
	console_error_panic_hook-0.1.7
	console_log-0.2.0
	cookie-factory-0.3.2
	copyless-0.1.5
	core-foundation-0.7.0
	core-foundation-0.9.3
	core-foundation-sys-0.7.0
	core-foundation-sys-0.8.3
	core-graphics-0.19.2
	core-graphics-0.22.3
	core-graphics-types-0.1.1
	core-video-sys-0.1.4
	coreaudio-rs-0.10.0
	coreaudio-sys-0.2.9
	cpal-0.13.5
	cpufeatures-0.2.1
	crc-1.8.1
	crc32fast-1.3.2
	crossbeam-channel-0.5.2
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.7
	crossbeam-utils-0.8.7
	crypto-common-0.1.3
	csv-1.1.6
	csv-core-0.1.10
	ctor-0.1.21
	cty-0.2.2
	curl-0.4.42
	curl-sys-0.4.52+curl-7.81.0
	d3d12-0.4.1
	darling-0.13.1
	darling_core-0.13.1
	darling_macro-0.13.1
	deflate-0.8.6
	deflate-1.0.0
	derivative-2.2.0
	derive-try-from-primitive-1.0.0
	diff-0.1.12
	digest-0.10.3
	dirs-4.0.0
	dirs-sys-0.3.6
	dispatch-0.2.0
	dlib-0.5.0
	downcast-rs-1.2.0
	easy-parallel-3.2.0
	either-1.6.1
	embed-resource-1.6.5
	encode_unicode-0.3.6
	encoding_rs-0.8.30
	enum-map-2.0.2
	enum-map-derive-0.8.0
	enumflags2-0.7.3
	enumflags2_derive-0.7.3
	enumset-1.0.8
	enumset_derive-0.5.5
	env_logger-0.9.0
	euclid-0.22.6
	event-listener-2.5.2
	fastrand-1.7.0
	flate2-1.0.22
	float_next_after-0.1.5
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.1
	funty-1.1.0
	futures-0.3.21
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-executor-0.3.21
	futures-io-0.3.21
	futures-lite-1.12.0
	futures-macro-0.3.21
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	fxhash-0.2.1
	gdk-pixbuf-sys-0.15.1
	gdk-sys-0.15.1
	generational-arena-0.2.8
	generic-array-0.14.5
	getrandom-0.2.5
	gif-0.11.3
	gio-sys-0.15.6
	glib-sys-0.15.6
	glob-0.3.0
	glow-0.11.2
	gobject-sys-0.15.5
	gpu-alloc-0.5.3
	gpu-alloc-types-0.2.0
	gpu-descriptor-0.2.2
	gpu-descriptor-types-0.1.1
	gtk-sys-0.15.3
	hashbrown-0.11.2
	hashbrown-0.9.1
	heck-0.4.0
	hermit-abi-0.1.19
	hex-0.4.3
	hexf-parse-0.2.1
	http-0.2.6
	humantime-2.1.0
	ident_case-1.0.1
	idna-0.2.3
	image-0.23.14
	indexmap-1.6.2
	indicatif-0.16.2
	inplace_it-0.3.3
	instant-0.1.12
	isahc-1.6.0
	itoa-0.4.8
	itoa-1.0.1
	jni-0.19.0
	jni-sys-0.3.0
	jobserver-0.1.24
	jpeg-decoder-0.1.22
	jpeg-decoder-0.2.2
	js-sys-0.3.55
	khronos-egl-4.1.0
	lazy_static-1.4.0
	lazycell-1.3.0
	lexical-core-0.7.6
	libc-0.2.119
	libflate-1.1.2
	libflate_lz77-1.1.0
	libloading-0.7.3
	libnghttp2-sys-0.1.7+1.45.0
	libz-sys-1.1.3
	lock_api-0.4.6
	log-0.4.14
	lyon-0.17.10
	lyon_algorithms-0.17.7
	lyon_geom-0.17.6
	lyon_path-0.17.7
	lyon_tessellation-0.17.10
	lzma-rs-0.2.0
	mach-0.3.2
	malloc_buf-0.0.6
	matches-0.1.9
	memchr-2.4.1
	memmap2-0.3.1
	memoffset-0.6.5
	metal-0.23.1
	mime-0.3.16
	minimal-lexical-0.2.1
	minimp3-0.5.1
	minimp3-sys-0.3.2
	miniz_oxide-0.3.7
	miniz_oxide-0.4.4
	miniz_oxide-0.5.1
	mio-0.8.0
	miow-0.3.7
	naga-0.8.5
	ndk-0.5.0
	ndk-0.6.0
	ndk-context-0.1.0
	ndk-glue-0.5.1
	ndk-glue-0.6.1
	ndk-macro-0.3.0
	ndk-sys-0.2.2
	ndk-sys-0.3.0
	nix-0.22.3
	nix-0.23.1
	nom-5.1.2
	nom-6.1.2
	nom-7.1.0
	ntapi-0.3.7
	num-complex-0.3.1
	num-derive-0.3.3
	num-integer-0.1.44
	num-iter-0.1.42
	num-rational-0.3.2
	num-traits-0.2.14
	num_cpus-1.13.1
	num_enum-0.5.6
	num_enum_derive-0.5.6
	number_prefix-0.4.0
	objc-0.2.7
	objc-foundation-0.1.1
	objc_exception-0.1.2
	objc_id-0.1.1
	oboe-0.4.5
	oboe-sys-0.4.5
	once_cell-1.9.0
	openssl-probe-0.1.5
	openssl-sys-0.9.72
	ordered-stream-0.0.1
	os_str_bytes-6.0.0
	output_vt100-0.1.3
	pango-sys-0.15.1
	parking-2.0.0
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	path-slash-0.1.4
	peeking_take_while-0.1.2
	percent-encoding-2.1.0
	pin-project-1.0.10
	pin-project-internal-1.0.10
	pin-project-lite-0.2.8
	pin-utils-0.1.0
	pkg-config-0.3.24
	png-0.16.8
	png-0.17.3
	polling-2.2.0
	pollster-0.2.5
	ppv-lite86-0.2.16
	pretty_assertions-1.1.0
	primal-check-0.3.1
	proc-macro-crate-1.1.3
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.36
	profiling-1.0.5
	quote-1.0.15
	radium-0.5.3
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	range-alloc-0.1.2
	raw-window-handle-0.4.2
	rayon-1.5.1
	rayon-core-1.9.1
	redox_syscall-0.2.10
	redox_users-0.4.0
	regex-1.5.4
	regex-automata-0.1.10
	regex-syntax-0.6.25
	regress-0.4.1
	renderdoc-sys-0.7.1
	rfd-0.7.0
	rle-decode-fast-1.0.3
	ron-0.7.0
	rustc-hash-1.1.0
	rustdct-0.6.0
	rustfft-5.1.1
	ryu-1.0.9
	safe_arch-0.6.0
	same-file-1.0.6
	schannel-0.1.19
	scoped-tls-1.0.0
	scoped_threadpool-0.1.9
	scopeguard-1.1.0
	serde-1.0.136
	serde_derive-1.0.136
	serde_json-1.0.79
	serde_repr-0.1.7
	sha1-0.6.1
	sha1_smol-1.0.0
	sha2-0.10.2
	shlex-0.1.1
	sid-0.6.1
	slab-0.4.5
	slice-deque-0.3.0
	slotmap-1.0.6
	sluice-0.5.5
	smallvec-1.8.0
	smithay-client-toolkit-0.15.3
	socket2-0.4.4
	spirv-0.2.0+1.5.4
	static_assertions-1.1.0
	stdweb-0.1.3
	strength_reduce-0.2.3
	strsim-0.10.0
	svg-0.10.0
	symphonia-0.5.0
	symphonia-bundle-mp3-0.5.0
	symphonia-core-0.5.0
	symphonia-metadata-0.5.0
	syn-1.0.86
	synstructure-0.12.6
	system-deps-6.0.2
	tap-1.0.1
	termcolor-1.1.2
	terminal_size-0.1.17
	textwrap-0.14.2
	thiserror-1.0.30
	thiserror-impl-1.0.30
	tiff-0.6.1
	time-0.1.43
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	toml-0.5.8
	tracing-0.1.31
	tracing-attributes-0.1.19
	tracing-core-0.1.22
	tracing-futures-0.2.5
	transpose-0.2.1
	typenum-1.15.0
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-width-0.1.9
	unicode-xid-0.2.2
	url-2.2.2
	vcpkg-0.2.15
	version-compare-0.1.0
	version_check-0.9.4
	vswhom-0.1.0
	vswhom-sys-0.1.1
	waker-fn-1.1.0
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wasm-bindgen-0.2.78
	wasm-bindgen-backend-0.2.78
	wasm-bindgen-futures-0.4.28
	wasm-bindgen-macro-0.2.78
	wasm-bindgen-macro-support-0.2.78
	wasm-bindgen-shared-0.2.78
	wayland-client-0.29.4
	wayland-commons-0.29.4
	wayland-cursor-0.29.4
	wayland-protocols-0.29.4
	wayland-scanner-0.29.4
	wayland-sys-0.29.4
	weak-table-0.3.2
	web-sys-0.3.55
	webbrowser-0.6.0
	weezl-0.1.5
	wepoll-ffi-0.1.2
	wgpu-0.12.0
	wgpu-core-0.12.2
	wgpu-hal-0.12.4
	wgpu-types-0.12.0
	wide-0.7.4
	widestring-0.5.1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.30.0
	windows_aarch64_msvc-0.30.0
	windows_i686_gnu-0.30.0
	windows_i686_msvc-0.30.0
	windows_x86_64_gnu-0.30.0
	windows_x86_64_msvc-0.30.0
	winit-0.26.1
	winreg-0.10.1
	wyz-0.2.0
	x11-clipboard-0.3.3
	x11-dl-2.19.1
	xcb-0.8.2
	xcursor-0.3.4
	xml-rs-0.8.4
	zbus-2.1.1
	zbus_macros-2.1.1
	zbus_names-2.1.0
	zvariant-3.1.2
	zvariant_derive-3.1.2"
# python is needed by xcb-0.8.2 until update to >=0.10
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="xml(+)"
inherit cargo desktop flag-o-matic python-any-r1 xdg

# 0(github) 1(repo) 2(commit hash) 3(crate:workspace,...) [see core/Cargo.toml]
RUFFLE_GIT=(
	"RustAudio dasp f05a703d247bb504d7e812b51e95f3765d9c5e94 dasp"
	"ruffle-rs gc-arena 4931b3bc25b2b74174ff5eb9c34ae0dda732778b gc-arena:src/gc-arena"
	"ruffle-rs h263-rs 023e14c73e565c4c778d41f66cfbac5ece6419b2 h263-rs:h263,h263-rs-yuv:yuv"
	"ruffle-rs nellymoser 77000f763b58021295429ca5740e3dc3b5228cbd nellymoser-rs:."
	"ruffle-rs nihav-vp6 9416fcc9fc8aab8f4681aa9093b42922214abbd3 nihav_codec_support:nihav-codec-support,nihav_core:nihav-core,nihav_duck:nihav-duck"
	"ruffle-rs quick-xml 8496365ec1412eb5ba5de350937b6bce352fa0ba quick-xml:."
	"ruffle-rs rust-flash-lso 19fecd07b9888c4bdaa66771c468095783b52bed flash-lso"
)
ruffle_uris() {
	cargo_crate_uris

	local g
	for g in "${RUFFLE_GIT[@]}"; do
		g=(${g})
		echo "https://github.com/${g[0]}/${g[1]}/archive/${g[2]}.tar.gz -> ${g[1]}-${g[2]}.tar.gz"
	done
}

# using _pYYYYMMDD over YYYY.MM.DD given ruffle has an underlaying version
# (0.1.0) which could get a non-nightly release eventually (YYYY. > 0.1.0)
MY_PV="nightly-${PV:3:4}-${PV:7:2}-${PV:9:2}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Flash Player emulator written in Rust"
HOMEPAGE="https://ruffle.rs/"
SRC_URI="
	https://github.com/ruffle-rs/ruffle/archive/refs/tags/${MY_PV}.tar.gz -> ${MY_P}.tar.gz
	$(ruffle_uris)"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 ISC MIT MPL-2.0 ZLIB curl"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/glib:2
	dev-libs/openssl:=
	media-libs/alsa-lib
	sys-libs/zlib:=
	x11-libs/gtk+:3
	x11-libs/libxcb:="
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	>=virtual/rust-1.56"

QA_FLAGS_IGNORED="
	usr/bin/${PN}
	usr/bin/${PN}_exporter
	usr/bin/${PN}_scanner"

src_prepare() {
	default

	# use [patch] directive to register git snapshots of needed crates
	local crate g
	for g in "${RUFFLE_GIT[@]}"; do
		g=(${g})
		echo "[patch.\"https://github.com/${g[0]}/${g[1]}\"]"
		for crate in ${g[3]//,/ }; do
			echo "${crate%:*} = { path = \"../${g[1]}-${g[2]}/${crate#*:}\" }"
		done
	done >> Cargo.toml || die
}

src_compile() {
	filter-flags '-flto*' # undefined references with ring crate and more

	cargo_src_compile --bins # note: configure --bins would skip tests
}

src_install() {
	dodoc README.md

	newicon web/packages/extension/assets/images/icon180.png ${PN}.png
	make_desktop_entry ${PN} ${PN^} ${PN} "AudioVideo;Player;Emulator;" \
		"MimeType=application/x-shockwave-flash;application/vnd.adobe.flash.movie;"

	cd target/$(usex debug{,} release) || die

	newbin ${PN}_desktop ${PN}
	newbin exporter ${PN}_exporter
	dobin ${PN}_scanner
}

pkg_postinst() {
	xdg_pkg_postinst

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "${PN} is experimental software that is still under heavy development"
		elog "and only receiving nightly releases. Plans in Gentoo is to update"
		elog "roughly every two weeks if no known major regressions."
		elog
		elog "There is currently no plans to support wasm builds / browser"
		elog "extensions, this provides the desktop viewer and other tools."
	fi
}
