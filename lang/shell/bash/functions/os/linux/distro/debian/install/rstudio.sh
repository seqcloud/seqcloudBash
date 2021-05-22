#!/usr/bin/env bash

koopa::debian_install_rstudio_server() { # {{{1
    # """
    # Install RStudio Server on Debian / Ubuntu.
    # @note Updated 2021-04-26.
    #
    # Verify install:
    # > sudo rstudio-server stop
    # > sudo rstudio-server verify-installation
    # > sudo rstudio-server start
    # > sudo rstudio-server status
    # """
    local arch os_codename
    koopa::assert_is_installed gdebi sudo
    arch="$(koopa::arch)"
    case "$arch" in
        x86_64)
            arch='amd64'
            ;;
    esac
    os_codename="$(koopa::os_codename)"
    case "$os_codename" in
        buster|focal)
            os_codename='bionic'
            ;;
        bionic)
            ;;
        *)
            koopa::stop "Unsupported OS version: '${os_codename}'."
            ;;
    esac
    koopa:::linux_install_rstudio_server \
        --file-ext='deb' \
        --install='sudo gdebi --non-interactive' \
        --os-codename="$os_codename" \
        --platform="$arch" \
        "$@"
    return 0
}

koopa::debian_install_rstudio_server_pro() { # {{{1
    koopa::debian_install_rstudio_server --pro "$@"
    return 0
}

koopa::debian_install_shiny_server() { # {{{1
    # """
    # Install Shiny Server for Debian/Ubuntu.
    # @note Updated 2021-05-22.
    # @seealso
    # https://rstudio.com/products/shiny/download-server/ubuntu/
    # """
    local arch arch2 name name_fancy pos r reinstall version
    # Currently only "amd64" (x86) is supported here.
    arch="$(koopa::arch)"
    r="$(koopa::locate_r)"
    case "$arch" in
        x86_64)
            arch2='amd64'
            ;;
        *)
            arch2="$arch"
            ;;
    esac
    reinstall=0
    pos=()
    while (("$#"))
    do
        case "$1" in
            --reinstall)
                reinstall=1
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
    koopa::assert_has_no_args "$#"
    koopa::assert_is_installed R gdebi sudo
    name='shiny-server'
    version="$(koopa::variable "$name")"
    name_fancy="Shiny Server ${version}"
    ! koopa::is_current_version "$name" && reinstall=1
    [[ "$reinstall" -eq 0 ]] && koopa::is_installed "$name" && return 0
    koopa::install_start "$name_fancy"
    tmp_dir="$(koopa::tmp_dir)"
    if ! koopa::is_r_package_installed shiny
    then
        koopa::alert 'Installing shiny R package.'
        (
            "$r" -e 'install.packages("shiny")'
        ) 2>&1 | tee "$(koopa::tmp_log_file)"
    fi
    (
        koopa::cd "$tmp_dir"
        file="shiny-server-${version}-${arch2}.deb"
        url="https://download3.rstudio.org/ubuntu-14.04/${arch}/${file}"
        koopa::download "$url"
        sudo gdebi --non-interactive "$file"
    ) 2>&1 | tee "$(koopa::tmp_log_file)"
    koopa::rm "$tmp_dir"
    koopa::install_success "$name_fancy"
    return 0
}

