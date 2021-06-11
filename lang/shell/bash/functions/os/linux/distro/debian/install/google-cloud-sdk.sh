#!/usr/bin/env bash

koopa::debian_install_google_cloud_sdk() { # {{{1
    # """
    # Install Google Cloud SDK.
    # @note Updated 2021-06-04.
    #
    # Required packages:
    # - apt-transport-https
    # - ca-certificates
    # - curl
    #
    # @seealso
    # - https://cloud.google.com/sdk/docs/downloads-apt-get
    # """
    koopa::assert_has_no_args "$#"
    name_fancy='Google Cloud SDK'
    if koopa::is_installed 'gcloud'
    then
        koopa::alert_is_installed "$name_fancy"
        return 0
    fi
    koopa::install_start "$name_fancy"
    koopa::debian_apt_add_google_cloud_sdk_repo
    koopa::debian_apt_install google-cloud-sdk
    koopa::install_success "$name_fancy"
    return 0
}

koopa::debian_uninstall_google_cloud_sdk() { # {{{1
    # """
    # Uninstall Google Cloud SDK.
    # @note Updated 2021-06-11.
    # """
    koopa::stop 'FIXME'
}