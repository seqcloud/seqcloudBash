#!/usr/bin/env bash

koopa::find_app_version() { # {{{1
    # """
    # Find the latest application version.
    # @note Updated 2020-11-22.
    # """
    local name prefix x
    koopa::assert_has_args "$#"
    name="${1:?}"
    prefix="$(koopa::app_prefix)"
    koopa::assert_is_dir "$prefix"
    prefix="${prefix}/${name}"
    koopa::assert_is_dir "$prefix"
    x="$( \
        find "$prefix" \
            -mindepth 1 \
            -maxdepth 1 \
            -type d \
        | sort \
        | tail -n 1 \
    )"
    koopa::assert_is_dir "$x"
    x="$(basename "$x")"
    koopa::print "$x"
    return 0
}

koopa::install_app() { # {{{1
    # """
    # Install application into a versioned directory structure.
    # @note Updated 2021-05-14.
    #
    # The 'dict' array approach has the benefit of avoiding passing unwanted
    # local variables to the internal installer function call below.
    # """
    local dict link_args pkgs pos
    koopa::assert_has_args "$#"
    koopa::assert_has_no_envs
    koopa::is_shared_install && koopa::assert_is_admin
    # Use a dictionary approach for storing configuration variables.
    declare -A dict=(
        [homebrew_opt]=''
        [installer]=''
        [link_app]=1
        [link_include_dirs]=''
        [name_fancy]=''
        [opt]=''
        [path_harden]=1
        [platform]=''
        [reinstall]=0
        [version]=''
    )
    # Any additional configuration variables (positional arguments) are passed
    # to the internal installer function below.
    pos=()
    while (("$#"))
    do
        case "$1" in
            --homebrew-opt=*)
                dict[homebrew_opt]="${1#*=}"
                shift 1
                ;;
            --installer=*)
                dict[installer]="${1#*=}"
                shift 1
                ;;
            --link-include-dirs=*)
                dict[link_include_dirs]="${1#*=}"
                shift 1
                ;;
            --name=*)
                dict[name]="${1#*=}"
                shift 1
                ;;
            --name-fancy=*)
                dict[name_fancy]="${1#*=}"
                shift 1
                ;;
            --no-link)
                dict[link_app]=0
                shift 1
                ;;
            --no-path-harden)
                dict[path_harden]=0
                shift 1
                ;;
            --opt=*)
                dict[opt]="${1#*=}"
                shift 1
                ;;
            --platform=*)
                dict[platform]="${1#*=}"
                shift 1
                ;;
            --reinstall|--force)
                dict[reinstall]=1
                shift 1
                ;;
            --version=*)
                dict[version]="${1#*=}"
                shift 1
                ;;
            --verbose)
                set -x
                shift 1
                ;;
            *)
                pos+=("$1")
                shift 1
                ;;
        esac
    done
    [[ "${#pos[@]}" -gt 0 ]] && set -- "${pos[@]}"
    [[ -z "${dict[installer]}" ]] && dict[installer]="${dict[name]}"
    dict[function]="$(koopa::snake_case_simple "${dict[installer]}")"
    dict[function]="install_${dict[function]}"
    [[ -n "${dict[platform]}" ]] && \
        dict[function]="${dict[platform]}_${dict[function]}"
    dict[function]="koopa:::${dict[function]}"
    if ! koopa::is_function "${dict[function]}"
    then
        koopa::stop 'Unsupported command.'
    fi
    [[ -z "${dict[name_fancy]}" ]] && dict[name_fancy]="${dict[name]}"
    [[ -z "${dict[version]}" ]] && \
        dict[version]="$(koopa::variable "${dict[name]}")"
    # Never link apps into make prefix on macOS.
    koopa::is_macos && dict[link_app]=0
    dict[prefix]="$(koopa::app_prefix)/${dict[name]}/${dict[version]}"
    dict[make_prefix]="$(koopa::make_prefix)"
    if [[ "${dict[reinstall]}" -eq 1 ]] && [[ -d "${dict[prefix]}" ]]
    then
        koopa::alert_note "Removing previous install at '${dict[prefix]}'."
        koopa::sys_rm "${dict[prefix]}"
    fi
    if [[ -d "${dict[prefix]}" ]]
    then
        koopa::alert_note "${dict[name_fancy]} is already installed \
at '${dict[prefix]}'."
        return 0
    fi
    koopa::install_start \
        "${dict[name_fancy]}" \
        "${dict[version]}" \
        "${dict[prefix]}"
    # Ensure configuration is minimal before proceeding, when desirable.
    if [[ "${dict[path_harden]}" -eq 1 ]]
    then
        declare -A conf_bak=(
            [LD_LIBRARY_PATH]="${LD_LIBRARY_PATH:-}"
            [PATH]="${PATH:-}"
            [PKG_CONFIG_PATH]="${PKG_CONFIG_PATH:-}"
        )
        PATH='/usr/bin:/bin:/usr/sbin:/sbin'
        export PATH
        unset -v LD_LIBRARY_PATH PKG_CONFIG_PATH
    fi
    # Activate packages installed in Homebrew opt.
    if [[ -n "${dict[homebrew_opt]}" ]]
    then
        IFS=',' read -r -a pkgs <<< "${dict[homebrew_opt]}"
        koopa::activate_homebrew_opt_prefix "${pkgs[@]}"
    fi
    # Activate packages installed in Koopa opt.
    if [[ -n "${dict[opt]}" ]]
    then
        IFS=',' read -r -a pkgs <<< "${dict[opt]}"
        koopa::activate_opt_prefix "${pkgs[@]}"
    fi
    if koopa::is_shared_install && koopa::is_installed ldconfig
    then
        sudo ldconfig || return 1
    fi
    dict[tmp_dir]="$(koopa::tmp_dir)"
    (
        koopa::cd "${dict[tmp_dir]}"
        export INSTALL_LINK_APP="${dict[link_app]}"
        export INSTALL_NAME="${dict[name]}"
        export INSTALL_PREFIX="${dict[prefix]}"
        export INSTALL_VERSION="${dict[version]}"
        "${dict[function]}" "$@"
    ) 2>&1 | tee "$(koopa::tmp_log_file)"
    koopa::rm "${dict[tmp_dir]}"
    koopa::sys_set_permissions -r "${dict[prefix]}"
    koopa::link_into_opt "${dict[prefix]}" "${dict[name]}"
    if [[ "${dict[link_app]}" -eq 1 ]]
    then
        koopa::delete_broken_symlinks "${dict[make_prefix]}"
        link_args=(
            "--name=${dict[name]}"
            "--version=${dict[version]}"
        )
        if [[ -n "${dict[link_include_dirs]}" ]]
        then
            link_args+=("--include-dirs=${dict[link_include_dirs]}")
        fi
        # Including the 'true' catch here to avoid 'cp' issues on Arch Linux.
        koopa::link_app "${link_args[@]}" || true
    fi
    if koopa::is_shared_install && koopa::is_installed ldconfig
    then
        sudo ldconfig || return 1
    fi
    # Reset global variables, if applicable.
    if [[ "${dict[path_harden]}" -eq 1 ]]
    then
        if [[ -n "${conf_bak[LD_LIBRARY_PATH]}" ]]
        then
            LD_LIBRARY_PATH="${conf_bak[LD_LIBRARY_PATH]}"
            export LD_LIBRARY_PATH
        fi
        if [[ -n "${conf_bak[PATH]}" ]]
        then
            PATH="${conf_bak[PATH]}"
            export PATH
        fi
        if [[ -n "${conf_bak[PKG_CONFIG_PATH]}" ]]
        then
            PKG_CONFIG_PATH="${conf_bak[PKG_CONFIG_PATH]}"
            export PKG_CONFIG_PATH
        fi
    fi
    koopa::install_success "${dict[name_fancy]}" "${dict[prefix]}"
    return 0
}

koopa::link_app() { # {{{1
    # """
    # Symlink application into build directory.
    # @note Updated 2021-04-26.
    #
    # If you run into permissions issues during link, check the build prefix
    # permissions. Ensure group is not 'root', and that group has write access.
    #
    # This can be reset easily with 'koopa::sys_set_permissions'.
    #
    # Note that Debian symlinks 'man' to 'share/man', which is non-standard.
    # This is currently corrected in 'install-debian-base', but top-level
    # symlink checks may need to be added here in a future update.
    #
    # @section cp flags:
    # * -f, --force
    # * -R, -r, --recursive
    # * -s, --symbolic-link
    #
    # @examples
    # koopa::link_app emacs 26.3
    # """
    local app_prefix app_subdirs cp_flags include_dirs make_prefix name \
        pos version
    include_dirs=''
    version=''
    pos=()
    while (("$#"))
    do
        case "$1" in
            --include-dirs=*)
                include_dirs="${1#*=}"
                shift 1
                ;;
            --name=*)
                name="${1#*=}"
                shift 1
                ;;
            --version=*)
                version="${1#*=}"
                shift 1
                ;;
            --)
                shift 1
                break
                ;;
            --*|-*)
                koopa::invalid_arg "$1"
                ;;
            *)
                pos+=("$1")
                shift 1
                ;;
        esac
    done
    [[ "${#pos[@]}" -gt 0 ]] && set -- "${pos[@]}"
    [[ -n "${1:-}" ]] && name="$1"
    [[ -z "$version" ]] && version="$(koopa::find_app_version "$name")"
    koopa::assert_has_no_envs
    make_prefix="$(koopa::make_prefix)"
    app_prefix="$(koopa::app_prefix)/${name}/${version}"
    koopa::assert_is_dir "$app_prefix" "$make_prefix"
    if koopa::is_macos
    then
        koopa::stop "Linking into '${make_prefix}' is not supported on macOS."
    fi
    koopa::alert "Linking '${app_prefix}' in '${make_prefix}'."
    koopa::sys_set_permissions -r "$app_prefix"
    koopa::delete_broken_symlinks "$app_prefix" "$make_prefix"
    app_subdirs=()
    if [[ -n "$include_dirs" ]]
    then
        IFS=',' read -r -a app_subdirs <<< "$include_dirs"
        app_subdirs=("${app_subdirs[@]/^/${app_prefix}}")
        for i in "${!app_subdirs[@]}"
        do
            app_subdirs[$i]="${app_prefix}/${app_subdirs[$i]}"
        done
    else
        readarray -t app_subdirs <<< "$( \
            find "$app_prefix" -mindepth 1 -maxdepth 1 -type d -print \
            | sort \
        )"
    fi
    # Copy as symbolic links.
    cp_flags=(
        '-s'
        '-t' "${make_prefix}"
    )
    koopa::is_shared_install && cp_flags+=('-S')
    koopa::cp "${cp_flags[@]}" "${app_subdirs[@]}"
    if koopa::is_linux && koopa::is_shared_install
    then
        koopa::update_ldconfig
    fi
    return 0
}

koopa::link_into_opt() { # {{{1
    # """
    # Link into koopa opt prefix.
    # @note Updated 2021-02-15.
    # """
    koopa::assert_has_args_eq "$#" 2
    local opt_prefix source_dir target_dir
    source_dir="${1:?}"
    opt_prefix="$(koopa::opt_prefix)"
    [[ ! -d "$opt_prefix" ]] && koopa::mkdir "$opt_prefix"
    target_dir="${opt_prefix}/${2:?}"
    koopa::alert "Linking '${source_dir}' in '${target_dir}'."
    [[ ! -d "$source_dir" ]] && koopa::mkdir "$source_dir"
    koopa::rm "$target_dir"
    koopa::sys_set_permissions "$opt_prefix"
    koopa::ln "$source_dir" "$target_dir"
    return 0
}

koopa::prune_apps() { # {{{1
    # """
    # Prune applications.
    # @note Updated 2021-01-04.
    # """
    if koopa::is_macos
    then
        koopa::alert_note 'App pruning not yet supported on macOS.'
        return 0
    fi
    koopa::rscript 'pruneApps' "$@"
    return 0
}

koopa::unlink_app() { # {{{1
    # """
    # Unlink an application.
    # @note Updated 2021-01-04.
    # """
    if koopa::is_macos
    then
        koopa::alert_note 'App links are not supported on macOS.'
        return 0
    fi
    koopa::rscript 'unlinkApp' "$@"
    return 0
}
