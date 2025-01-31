TERMUX_PKG_HOMEPAGE=https://sing-box.sagernet.org
TERMUX_PKG_DESCRIPTION="The universal proxy platform"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="kay9925@outlook.com"
TERMUX_PKG_VERSION="1.10.7"
TERMUX_PKG_SRCURL="https://github.com/SagerNet/sing-box/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=402b618148b58f5ff6c1bee4f4fdcf7cdcb88a2df6a8bd682ea742a89b5be9ec
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	local tags="with_gvisor,with_quic,with_wireguard,with_utls,with_clash_api"
	local ldflags="\
	-w -s \
	-X 'github.com/sagernet/sing-box/constant.Version=${TERMUX_PKG_VERSION}' \
	"

	export CGO_ENABLED=1

	go build \
		-trimpath \
		-tags "${tags}" \
		-ldflags="${ldflags}" \
		-o "${TERMUX_PKG_NAME}" \
		./cmd/sing-box

}

termux_step_make_install() {
	install -Dm700 ./${TERMUX_PKG_NAME} ${TERMUX_PREFIX}/bin

	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/bash-completion/completions/sing-box.bash"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/fish/vendor_completions.d/sing-box.fish"
	install -Dm644 /dev/null "${TERMUX_PREFIX}/share/zsh/site-functions/_sing-box"

}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
		#!${TERMUX_PREFIX}/bin/sh
		sing-box completion bash > ${TERMUX_PREFIX}/share/bash-completion/completions/sing-box.bash
		sing-box completion fish > ${TERMUX_PREFIX}/share/fish/vendor_completions.d/sing-box.fish
		sing-box completion zsh > ${TERMUX_PREFIX}/share/zsh/site-functions/_sing-box
	EOF
}
