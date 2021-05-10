#!/usr/bin/env bash

koopa::install_dotfiles() { # {{{1
    # """
    # Install dot files.
    # @note Updated 2021-05-10.
    # """
    local koopa_prefix name_fancy prefix reinstall script
    name_fancy='dotfiles'
    prefix="$(koopa::dotfiles_prefix)"
    reinstall=0
    while (("$#"))
    do
        case "$1" in
            --reinstall)
                reinstall=1
                shift 1
                ;;
            *)
                koopa::invalid_arg "$1"
                ;;
        esac
    done
    if [[ -d "$prefix" ]] && [[ "$reinstall" -eq 0 ]]
    then
        koopa::alert_note "${name_fancy} already installed at '${prefix}'."
        return 0
    fi
    koopa::install_start "$name_fancy" "$prefix"
    koopa_prefix="$(koopa::prefix)"
    koopa::add_to_path_start "${koopa_prefix}/bin"
    [[ ! -d "$prefix" ]] && koopa::git_clone_dotfiles
    koopa::add_config_link "$prefix"
    script="${prefix}/install"
    koopa::assert_is_file "$script"
    "$script"
    koopa::install_success "$name_fancy" "$prefix"
    return 0
}

koopa::install_dotfiles_private() { # {{{1
    # """
    # Install private dot files.
    # @note Updated 2021-05-10.
    # """
    local name_fancy prefix reinstall script
    name_fancy='Private dotfiles'
    prefix="$(koopa::dotfiles_private_prefix)"
    reinstall=0
    while (("$#"))
    do
        case "$1" in
            --reinstall)
                reinstall=1
                shift 1
                ;;
            *)
                koopa::invalid_arg "$1"
                ;;
        esac
    done
    if [[ -d "$prefix" ]] && [[ "$reinstall" -eq 0 ]]
    then
        koopa::alert_note "${name_fancy} already installed at '${prefix}'."
        return 0
    fi
    koopa::install_start "$name_fancy" "$prefix"
    koopa::add_monorepo_config_link 'dotfiles-private'
    [[ ! -d "$prefix" ]] && koopa::git_clone_dotfiles_private
    script="${prefix}/install"
    koopa::assert_is_file "$script"
    "$script"
    koopa::install_success "$name_fancy" "$prefix"
    return 0
}

koopa::uninstall_dotfiles() { # {{{1
    # """
    # Uninstall dot files.
    # @note Updated 2020-07-05.
    # """
    local prefix script
    koopa::assert_has_no_args "$#"
    prefix="$(koopa::dotfiles_prefix)"
    if [[ ! -d "$prefix" ]]
    then
        koopa::alert_note "No dotfiles at '${prefix}'."
        return 0
    fi
    script="${prefix}/uninstall"
    koopa::assert_is_file "$script"
    "$script"
    return 0
}

koopa::uninstall_dotfiles_private() { # {{{1
    # """
    # Uninstall private dot files.
    # @note Updated 2020-07-05.
    # """
    local prefix script
    koopa::assert_has_no_args "$#"
    prefix="$(koopa::dotfiles_private_prefix)"
    if [[ ! -d "$prefix" ]]
    then
        koopa::alert_note "No private dotfiles at '${prefix}'."
        return 0
    fi
    script="${prefix}/uninstall"
    koopa::assert_is_file "$script"
    "$script"
    return 0
}

koopa::update_dotfiles() { # {{{1
    # """
    # Update dotfiles repo and run install script, if defined.
    # @note Updated 2021-05-05.
    # """
    local config_prefix repo repos script
    if [[ "$#" -eq 0 ]]
    then
        config_prefix="$(koopa::config_prefix)"
        repos=(
            "${config_prefix}/dotfiles"
            "${config_prefix}/dotfiles-private"
        )
    else
        repos=("$@")
    fi
    for repo in "${repos[@]}"
    do
        [[ -d "$repo" ]] || continue
        (
            koopa::update_start "$repo"
            koopa::cd "$repo"
            # Run the updater script, if defined.
            script="${repo}/update"
            if [[ -x "$script" ]]
            then
                "$script"
            else
                koopa::git_reset
                koopa::git_pull
            fi
            # Run the install script, if defined.
            script="${repo}/install"
            [[ -x "$script" ]] && "$script"
            koopa::update_success "$repo"
        )
    done
    return 0
}
