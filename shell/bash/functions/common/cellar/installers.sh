#!/usr/bin/env bash

koopa::install_autoconf() { # {{{1
    koopa::install_cellar \
        --name='autoconf' \
        "$@"
}

koopa::install_autojump() { # {{{1
    koopa::install_cellar \
        --name='autojump' \
        "$@"
}

koopa::install_automake() { # {{{1
    koopa::install_cellar \
        --name='automake' \
        "$@"
}

koopa::install_aws_cli() { # {{{1
    koopa::install_cellar \
        --name='aws-cli' \
        --name-fancy='AWS CLI' \
        --version='latest' \
        --include-dirs='bin' \
        "$@"
}

koopa::install_bash() { # {{{1
    koopa::install_cellar \
        --name='bash' \
        --name-fancy='Bash' \
        "$@"
}

koopa::install_binutils() { # {{{1
    koopa::install_cellar \
        --name='binutils' \
        "$@"
}

koopa::install_cmake() { # {{{1
    koopa::install_cellar \
        --name='cmake' \
        --name-fancy='CMake' \
        "$@"
}

koopa::install_coreutils() { # {{{1
    koopa::install_cellar \
        --name='coreutils' \
        "$@"
}

koopa::install_curl() { # {{{1
    koopa::install_cellar \
        --name='curl' \
        --name-fancy='cURL' \
        "$@"
}

koopa::install_docker_credential_pass() { # {{{1
    koopa::install_cellar \
        --name='docker-credential-pass' \
        "$@"
}

koopa::install_emacs() { # {{{1
    koopa::install_cellar \
        --name='emacs' \
        --name-fancy='Emacs' \
        "$@"
}

koopa::install_findutils() { # {{{1
    koopa::install_cellar \
        --name='findutils' \
        "$@"
}

koopa::install_fish() { # {{{1
    koopa::install_cellar \
        --name='fish' \
        --name-fancy='Fish' \
        "$@"
}

koopa::install_gawk() { # {{{1
    koopa::install_cellar \
        --name='gawk' \
        --name-fancy='GNU awk' \
        "$@"
}

koopa::install_gcc() { # {{{1
    koopa::install_cellar \
        --name='gcc' \
        --name-fancy='GCC' \
        "$@"
}

koopa::install_gdal() { # {{{1
    koopa::install_cellar \
        --name='gdal' \
        --name-fancy='GDAL' \
        "$@"
}

koopa::install_geos() { # {{{1
    koopa::install_cellar \
        --name='geos' \
        --name-fancy='GEOS' \
        "$@"
}

koopa::install_git() { # {{{1
    koopa::install_cellar \
        --name='git' \
        --name-fancy='Git' \
        "$@"
}

koopa::install_gnupg() { # {{{1
    koopa::install_cellar \
        --name='gnupg' \
        --name-fancy='GnuPG suite' \
        "$@"
    koopa::is_installed gpg-agent && gpgconf --kill gpg-agent
    return 0
}

koopa::install_grep() { # {{{1
    koopa::install_cellar \
        --name='grep' \
        "$@"
}

koopa::install_gsl() { # {{{1
    koopa::install_cellar \
        --name='gsl' \
        --name-fancy='GSL' \
        --cellar-only \
        "$@"
}

koopa::install_hdf5() { # {{{1
    koopa::install_cellar \
        --name='hdf5' \
        --name-fancy='HDF5' \
        "$@"
}

koopa::install_htop() { # {{{1
    koopa::install_cellar \
        --name='htop' \
        "$@"
}

koopa::install_julia() { # {{{1
    local install_type pos
    install_type='binary'
    pos=()
    while (("$#"))
    do
        case "$1" in
            --binary)
                install_type='binary'
                shift 1
                ;;
            --source)
                install_type='source'
                shift 1
                ;;
            *)
                pos+=("$1")
                shift 1
                ;;
        esac
    done
    [[ "${#pos[@]}" -gt 0 ]] && set -- "${pos[@]}"
    koopa::install_cellar \
        --name='julia' \
        --name-fancy='Julia' \
        --script-name="julia-${install_type}" \
        "$@"
}

koopa::install_libevent() { # {{{1
    koopa::install_cellar \
        --name='libevent' \
        "$@"
}

koopa::install_libtool() { # {{{1
    koopa::install_cellar \
        --name='libtool' \
        "$@"
}

koopa::install_lua() { # {{{1
    koopa::install_cellar \
        --name='lua' \
        --name-fancy='Lua' \
        "$@"
}

koopa::install_luarocks() { # {{{1
    koopa::install_cellar \
        --name='luarocks' \
        "$@"
}

koopa::install_make() { # {{{1
    koopa::install_cellar \
        --name='make' \
        "$@"
}

koopa::install_ncurses() { # {{{1
    koopa::install_cellar \
        --name='ncurses' \
        "$@"
}

koopa::install_neofetch() { # {{{1
    koopa::install_cellar \
        --name='neofetch' \
        "$@"
}

koopa::install_neovim() { # {{{1
    koopa::install_cellar \
        --name='neovim' \
        "$@"
}

koopa::install_openssh() { # {{{1
    koopa::install_cellar \
        --name='openssh' \
        --name-fancy='OpenSSH' \
        "$@"
}

koopa::install_openssl() { # {{{1
    koopa::install_cellar \
        --name='openssl' \
        --name-fancy='OpenSSL' \
        --cellar-only \
        "$@"
}

koopa::install_parallel() { # {{{1
    koopa::install_cellar \
        --name='parallel' \
        "$@"
}

koopa::install_password_store() { # {{{1
    # """
    # https://www.passwordstore.org/
    # https://git.zx2c4.com/password-store/
    # """
    koopa::install_cellar \
        --name='password-store' \
        "$@"
}

koopa::install_patch() { # {{{1
    koopa::install_cellar \
        --name='patch' \
        "$@"
}

koopa::install_perl() { # {{{1
    koopa::install_cellar \
        --name='perl' \
        --name-fancy='Perl' \
        "$@"
}

koopa::install_pkg_config() { # {{{1
    koopa::install_cellar \
        --name='pkg-config' \
        "$@"
}

koopa::install_proj() { # {{{1
    koopa::install_cellar \
        --name='proj' \
        --name-fancy='PROJ' \
        "$@"
}

koopa::install_pyenv() { # {{{1
    koopa::install_cellar \
        --name='pyenv' \
        "$@"
}

koopa::install_python() { # {{{1
    koopa::install_cellar \
        --name='python' \
        --name-fancy='Python' \
        "$@"
    koopa::install_py_koopa
}

koopa::install_r() { # {{{1
    koopa::install_cellar \
        --name='r' \
        --name-fancy='R' \
        "$@"
    koopa::update_r_config
}

koopa::install_rbenv() { # {{{1
    koopa::install_cellar \
        --name='rbenv' \
        "$@"
}

koopa::install_rmate() { # {{{1
    koopa::install_cellar \
        --name='rmate' \
        "$@"
}

koopa::install_rsync() { # {{{1
    koopa::install_cellar \
        --name='rsync' \
        "$@"
}

koopa::install_ruby() { # {{{1
    koopa::install_cellar \
        --name='ruby' \
        --name-fancy='Ruby' \
        "$@"
}

koopa::install_sed() { # {{{1
    koopa::install_cellar \
        --name='sed' \
        "$@"
}

koopa::install_shellcheck() { # {{{1
    koopa::install_cellar \
        --name='shellcheck' \
        --name-fancy='ShellCheck' \
        "$@"
}

koopa::install_shunit2() { # {{{1
    koopa::install_cellar \
        --name='shunit2' \
        --name-fancy='shUnit2' \
        "$@"
}

koopa::install_singularity() { # {{{1
    koopa::install_cellar \
        --name='singularity' \
        "$@"
}

koopa::install_sqlite() { # {{{1
    koopa::install_cellar \
        --name='sqlite' \
        --name-fancy='SQLite' \
        "$@"
    koopa::note 'Reinstall PROJ and GDAL, if built from source.'
    return 0
}

koopa::install_subversion() { # {{{1
    koopa::install_cellar \
        --name='subversion' \
        "$@"
}

koopa::install_taglib() { # {{{1
    koopa::install_cellar \
        --name='taglib' \
        --name-fancy='TagLib' \
        "$@"
}

koopa::install_texinfo() { # {{{1
    koopa::install_cellar \
        --name='texinfo' \
        "$@"
}

koopa::install_the_silver_searcher() { # {{{1
    koopa::install_cellar \
        --name='the-silver-searcher' \
        "$@"
}

koopa::install_tmux() { # {{{1
    koopa::install_cellar \
        --name='tmux' \
        "$@"
}

koopa::install_udunits() { # {{{1
    koopa::install_cellar \
        --name='udunits' \
        "$@"
}

koopa::install_vim() { # {{{1
    koopa::install_cellar \
        --name='vim' \
        --name-fancy='Vim' \
        "$@"
}

koopa::install_wget() { # {{{1
    koopa::install_cellar \
        --name='wget' \
        "$@"
}

koopa::install_zsh() { # {{{1
    koopa::install_cellar \
        --name='zsh' \
        --name-fancy='Zsh' \
        "$@"
    koopa::fix_zsh_permissions
    return 0
}