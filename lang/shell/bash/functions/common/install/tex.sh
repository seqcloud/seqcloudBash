#!/usr/bin/env bash

# FIXME Need to add an uninstaller.

koopa::update_tex() { # {{{1
    # """
    # Update TeX.
    # @note Updated 2021-05-05.
    # """
    local name_fancy
    koopa::assert_has_no_args "$#"
    koopa::assert_is_installed 'tlmgr'
    koopa::assert_is_admin
    name_fancy='TeX packages'
    koopa::update_start "$name_fancy"
    sudo tlmgr update --self
    sudo tlmgr update --list
    sudo tlmgr update --all
    koopa::update_success "$name_fancy"
    return 0
}
