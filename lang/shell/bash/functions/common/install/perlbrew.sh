#!/usr/bin/env bash

koopa::install_perlbrew() { # {{{1
    koopa::install_app \
        --name-fancy='Perlbrew' \
        --name='perlbrew' \
        --no-link \
        --version='rolling' \
        "$@"
}

koopa:::install_perlbrew() { # {{{1
    # """
    # Install Perlbrew.
    # @note Updated 2021-05-25.
    #
    # Available releases:
    # > perlbrew available
    # """
    local file prefix url
    prefix="${INSTALL_PREFIX:?}"
    koopa::mkdir "$prefix"
    koopa::rm "${HOME:?}/.perlbrew"
    file='install.sh'
    url='https://install.perlbrew.pl'
    koopa::download "$url" "$file"
    koopa::chmod +x "$file"
    export PERLBREW_ROOT="$prefix"
    "./${file}"
}

koopa::uninstall_perlbrew() { # {{{1
    koopa::uninstall_app \
        --name-fancy='Perlbrew' \
        --name='perlbrew' \
        --no-link \
        "$@"
}

koopa::update_perlbrew() { # {{{1
    # """
    # Update Perlbrew.
    # @note Updated 2021-05-25.
    # """
    koopa::assert_has_no_args "$#"
    koopa::assert_has_no_envs
    koopa::activate_perlbrew
    if ! koopa::is_installed 'perlbrew'
    then
        koopa::alert_is_not_installed 'perlbrew'
        return 0
    fi
    koopa::h1 'Updating Perlbrew.'
    perlbrew self-upgrade
    return 0
}

