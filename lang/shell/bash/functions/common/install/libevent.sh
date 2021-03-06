#!/usr/bin/env bash

# [2021-05-27] macOS success.

koopa::install_libevent() { # {{{1
    koopa::install_app \
        --name='libevent' \
        "$@"
}

koopa:::install_libevent() { # {{{1
    # """
    # Install libevent.
    # @note Updated 2021-05-26.
    # """
    local file jobs name prefix url version
    prefix="${INSTALL_PREFIX:?}"
    version="${INSTALL_VERSION:?}"
    jobs="$(koopa::cpu_count)"
    make="$(koopa::locate_make)"
    name='libevent'
    if koopa::is_macos
    then
        koopa::activate_homebrew_opt_prefix 'openssl@1.1'
    fi
    file="${name}-${version}-stable.tar.gz"
    url="https://github.com/${name}/${name}/releases/download/\
release-${version}-stable/${file}"
    koopa::download "$url"
    koopa::extract "$file"
    koopa::cd "${name}-${version}-stable"
    ./configure --prefix="$prefix"
    "$make" --jobs="$jobs"
    # > "$make" check
    "$make" install
    return 0
}

koopa::uninstall_libevent() { # {{{1
    koopa::uninstall_app \
        --name='libevent' \
        "$@"
}
