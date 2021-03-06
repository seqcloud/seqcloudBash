#!/usr/bin/env bash

koopa::install_vim() { # {{{1
    koopa::install_app \
        --name-fancy='Vim' \
        --name='vim' \
        "$@"
}

koopa:::install_vim() { # {{{1
    # """
    # Install Vim.
    # @note Updated 2021-05-25.
    #
    # On Ubuntu, '--enable-rubyinterp' currently causing a false positive error
    # related to ncurses, even when '--with-tlib' is correctly set.
    #
    # @seealso
    # - https://github.com/vim/vim/issues/1081
    # """
    local conf_args file jobs make name prefix python python_config
    local python_config_dir url version
    prefix="${INSTALL_PREFIX:?}"
    version="${INSTALL_VERSION:?}"
    make="$(koopa::locate_make)"
    jobs="$(koopa::cpu_count)"
    if koopa::is_linux
    then
        koopa::activate_opt_prefix 'python'
    elif koopa::is_macos
    then
        koopa::macos_activate_python
    fi
    python="$(koopa::locate_python)"
    python_config="${python}-config"
    koopa::assert_is_installed "$python" "$python_config"
    python_config_dir="$("$python_config" --configdir)"
    conf_args=(
        "--prefix=${prefix}"
        "--with-python3-command=${python}"
        "--with-python3-config-dir=${python_config_dir}"
        '--enable-python3interp'
    )
    if koopa::is_linux
    then
        conf_args+=(
            "LDFLAGS=-Wl,-rpath=${prefix}/lib"
        )
    elif koopa::is_macos
    then
        conf_args+=(
            '--enable-cscope'
            '--enable-gui=no'
            '--enable-luainterp'
            '--enable-multibyte'
            '--enable-perlinterp'
            '--enable-rubyinterp'
            '--enable-terminal'
            '--with-tlib=ncurses'
            '--without-x'
        )
    fi
    name='vim'
    file="v${version}.tar.gz"
    url="https://github.com/${name}/${name}/archive/${file}"
    koopa::download "$url"
    koopa::extract "$file"
    koopa::cd "${name}-${version}"
    ./configure "${conf_args[@]}"
    "$make" --jobs="$jobs"
    # > "$make" test
    "$make" install
    return 0
}

koopa::uninstall_vim() { # {{{1
    koopa::uninstall_app \
        --name-fancy='Vim' \
        --name='vim' \
        "$@"
}
