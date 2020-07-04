#!/bin/sh
# shellcheck disable=SC2039

koopa::check_azure() { # {{{1
    # """
    # Check Azure VM integrity.
    # @note Updated 2019-10-31.
    # """
    koopa::assert_has_no_args "$#"
    koopa::is_azure || return 0
    if [ -e "/mnt/resource" ]
    then
        koopa::check_user "/mnt/resource" "root"
        koopa::check_group "/mnt/resource" "root"
        koopa::check_access_octal "/mnt/resource" "1777"
    fi
    koopa::check_mount "/mnt/rdrive"
    return 0
}

koopa::check_access_human() { # {{{1
    # """
    # Check if file or directory has expected human readable access.
    # @note Updated 2020-01-12.
    # """
    koopa::assert_has_args "$#"
    local file
    file="${1:?}"
    local code
    code="${2:?}"
    if [ ! -e "$file" ]
    then
        koopa::warning "'${file}' does not exist."
        return 1
    fi
    local access
    access="$(koopa::stat_access_human "$file")"
    if [ "$access" != "$code" ]
    then
        koopa::warning "'${file}' current access '${access}' is not '${code}'."
    fi
    return 0
}

koopa::check_access_octal() { # {{{1
    # """
    # Check if file or directory has expected octal access.
    # @note Updated 2020-01-12.
    # """
    koopa::assert_has_args "$#"
    local file
    file="${1:?}"
    local code
    code="${2:?}"
    if [ ! -e "$file" ]
    then
        koopa::warning "'${file}' does not exist."
        return 1
    fi
    local access
    access="$(koopa::stat_access_octal "$file")"
    if [ "$access" != "$code" ]
    then
        koopa::warning "'${file}' current access '${access}' is not '${code}'."
    fi
    return 0
}

koopa::check_group() { # {{{1
    # """
    # Check if file or directory has an expected group.
    # @note Updated 2020-01-12.
    # """
    koopa::assert_has_args "$#"
    local file
    file="${1:?}"
    local code
    code="${2:?}"
    if [ ! -e "$file" ]
    then
        koopa::warning "'${file}' does not exist."
        return 1
    fi
    local group
    group="$(koopa::stat_group "$file")"
    if [ "$group" != "$code" ]
    then
        koopa::warning "'${file}' current group '${group}' is not '${code}'."
        return 1
    fi
    return 0
}

koopa::check_mount() { # {{{1
    # """
    # Check if a drive is mounted.
    # Usage of find is recommended over ls here.
    # @note Updated 2020-06-30.
    # """
    koopa::assert_has_args "$#"
    koopa::assert_is_installed find
    local mnt
    mnt="${1:?}"
    if [ "$(find "$mnt" -mindepth 1 -maxdepth 1 | wc -l)" -eq 0 ]
    then
        koopa::warning "'${mnt}' is unmounted."
        return 1
    fi
    return 0
}

koopa::check_user() { # {{{1
    # """
    # Check if file or directory is owned by an expected user.
    # @note Updated 2020-01-13.
    # """
    koopa::assert_has_args "$#"
    local file
    file="${1:?}"
    if [ ! -e "$file" ]
    then
        koopa::warning "'${file}' does not exist on disk."
        return 1
    fi
    file="$(realpath "$file")"
    local expected_user
    expected_user="${2:?}"
    local current_user
    current_user="$(koopa::stat_user "$file")"
    if [ "$current_user" != "$expected_user" ]
    then
        koopa::warning "'${file}' user '${current_user}' is not \
'${expected_user}'."
        return 1
    fi
    return 0
}
