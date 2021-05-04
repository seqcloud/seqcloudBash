#!/usr/bin/env bash

koopa::linux_install_openssl() { # {{{1
    koopa::linux_install_app \
        --name='openssl' \
        --name-fancy='OpenSSL' \
        --no-link \
        "$@"
}

koopa:::linux_install_openssl() { # {{{1
    # """
    # Install OpenSSL.
    # @note Updated 2021-05-04.
    # """
    local file prefix url version
    koopa::assert_is_linux
    prefix="${INSTALL_PREFIX:?}"
    version="${INSTALL_VERSION:?}"
    name='openssl'
    jobs="$(koopa::cpu_count)"
    file="${name}-${version}.tar.gz"
    url="https://www.${name}.org/source/${file}"
    koopa::download "$url"
    koopa::extract "$file"
    koopa::cd "${name}-${version}"
    ./config \
        --prefix="$prefix" \
        --openssldir="$prefix" \
        shared
    make --jobs="$jobs"
    # > make test
    make install
    return 0
}