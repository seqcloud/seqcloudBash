#!/bin/sh

__koopa_id() { # {{{1
    # """
    # Return ID string.
    # @note Updated 2021-05-25.
    # """
    local x
    [ "$#" -gt 0 ] || return 1
    x="$(id "$@")"
    [ -n "$x" ] || return 1
    _koopa_print "$x"
    return 0
}

_koopa_arch() { # {{{1
    # """
    # Platform architecture.
    # @note Updated 2021-05-26.
    #
    # e.g. Intel: x86_64; ARM: aarch64.
    # """
    local uname x
    [ "$#" -eq 0 ] || return 1
    uname='uname'
    x="$("$uname" -m)"
    [ -n "$x" ] || return 1
    _koopa_print "$x"
    return 0
}

_koopa_arch2() { # {{{1
    # """
    # Alternative platform architecture.
    # @note Updated 2021-05-26.
    #
    # e.g. Intel: amd64; ARM: arm64.
    #
    # @seealso
    # - https://wiki.debian.org/ArchitectureSpecificsMemo
    # """
    local x
    [ "$#" -eq 0 ] || return 1
    x="$(_koopa_arch)"
    case "$x" in
        aarch64)
            x='arm64'
            ;;
        x86_64)
            x='amd64'
            ;;
        *)
            return 1
            ;;
    esac
    [ -n "$x" ] || return 1
    _koopa_print "$x"
    return 0
}

_koopa_cpu_count() { # {{{1
    # """
    # Return a usable number of CPU cores.
    # @note Updated 2020-07-21.
    #
    # Dynamically assigns 'n-1' or 'n-2' depending on the machine power.
    # """
    local n
    [ "$#" -eq 0 ] || return 1
    if _koopa_is_installed nproc
    then
        n="$(nproc)"
    elif _koopa_is_macos
    then
        n="$(sysctl -n hw.ncpu)"
    elif _koopa_is_linux
    then
        n="$(getconf _NPROCESSORS_ONLN)"
    else
        # Otherwise assume single threaded.
        n=1
    fi
    # Subtract some cores for login use on powerful machines.
    [ "$n" -ge 17 ] && n=$((n - 2))
    _koopa_print "$n"
    return 0
}

_koopa_debian_os_codename() { # {{{1
    # """
    # Debian operating system codename.
    # @note Updated 2021-06-02.
    # """
    local x
    [ "$#" -eq 0 ] || return 1
    _koopa_is_installed 'lsb_release' || return 0
    x="$(lsb_release -cs)"
    [ -n "$x" ] || return 1
    _koopa_print "$x"
    return 0
}

_koopa_git_branch() { # {{{1
    # """
    # Current git branch name.
    # @note Updated 2021-05-26.
    #
    # This is used in prompt, so be careful with assert checks.
    #
    # Handles detached HEAD state.
    #
    # Alternatives:
    # > git name-rev --name-only HEAD
    # > git rev-parse --abbrev-ref HEAD
    #
    # @seealso
    # - https://git.kernel.org/pub/scm/git/git.git/tree/contrib/completion/
    #       git-completion.bash?id=HEAD
    # """
    local branch
    [ "$#" -eq 0 ] || return 1
    _koopa_is_git || return 0
    git='git'
    branch="$("$git" symbolic-ref --short -q 'HEAD' 2>/dev/null)"
    _koopa_print "$branch"
    return 0
}

_koopa_group() { # {{{1
    # """
    # Current user's default group.
    # @note Updated 2020-06-30.
    # """
    [ "$#" -eq 0 ] || return 1
    __koopa_id -gn
    return 0
}

_koopa_group_id() { # {{{1
    # """
    # Current user's default group ID.
    # @note Updated 2020-06-30.
    # """
    [ "$#" -eq 0 ] || return 1
    __koopa_id -g
    return 0
}

_koopa_hostname() { # {{{1
    # """
    # Host name.
    # @note Updated 2021-05-21
    # """
    local uname
    [ "$#" -eq 0 ] || return 1
    uname='uname'
    x="$("$uname" -n)"
    [ -n "$x" ] || return 1
    _koopa_print "$x"
    return 0
}

_koopa_host_id() { # {{{1
    # """
    # Simple host ID string to load up host-specific scripts.
    # @note Updated 2020-11-11.
    #
    # Currently intended to support AWS, Azure, and Harvard clusters.
    #
    # Returns useful host type matching either:
    # - VMs: aws, azure.
    # - HPCs: harvard-o2, harvard-odyssey.
    #
    # Returns empty for local machines and/or unsupported types.
    #
    # Alternatively, can use 'hostname -d' for reverse lookups.
    # """
    local id
    [ "$#" -eq 0 ] || return 1
    if [ -r '/etc/hostname' ]
    then
        id="$(cat '/etc/hostname')"
    elif _koopa_is_installed hostname
    then
        id="$(hostname -f)"
    else
        return 0
    fi
    case "$id" in
        # VMs {{{2
        # ----------------------------------------------------------------------
        *.ec2.internal)
            id='aws'
            ;;
        awslab*)
            id='aws'
            ;;
        azlab*)
            id='azure'
            ;;
        # HPCs {{{2
        # ----------------------------------------------------------------------
        *.o2.rc.hms.harvard.edu)
            id='harvard-o2'
            ;;
        *.rc.fas.harvard.edu)
            id='harvard-odyssey'
            ;;
    esac
    [ -n "$id" ] || return 1
    _koopa_print "$id"
    return 0
}

_koopa_macos_color_mode() { # {{{1
    # """
    # macOS color mode (dark/light) value.
    # @note Updated 2021-05-07.
    # """
    local x
    [ "$#" -eq 0 ] || return 1
    if _koopa_macos_is_dark_mode
    then
        x='dark'
    else
        x='light'
    fi
    _koopa_print "$x"
}

_koopa_macos_os_codename() { # {{{1
    # """
    # macOS OS codename (marketing name).
    # @note Updated 2021-06-02.
    # @seealso
    # - https://apple.stackexchange.com/questions/333452/
    # - https://unix.stackexchange.com/questions/234104/
    # """
    local version x
    [ "$#" -eq 0 ] || return 1
    version="$(_koopa_macos_version)"
    case "$version" in
        11.*)
            x='Big Sur'
            ;;
        10.15.*)
            x='Catalina'
            ;;
        10.14.*)
            x='Mojave'
            ;;
        10.13.*)
            x='High Sierra'
            ;;
        10.12.*)
            x='Sierra'
            ;;
        10.11.*)
            x='El Capitan'
            ;;
        10.10.*)
            x='Yosmite'
            ;;
        10.9.*)
            x='Mavericks'
            ;;
        10.8.*)
            x='Mountain Lion'
            ;;
        10.7.*)
            x='Lion'
            ;;
        10.6.*)
            x='Snow Leopard'
            ;;
        10.5.*)
            x='Leopard'
            ;;
        10.4.*)
            x='Tiger'
            ;;
        10.3.*)
            x='Panther'
            ;;
        10.2.*)
            x='Jaguar'
            ;;
        10.1.*)
            x='Puma'
            ;;
        10.0.*)
            x='Cheetah'
            ;;
        *)
            return 1
            ;;
    esac
    [ -n "$x" ] || return 1
    _koopa_print "$x"
    return 0
}

_koopa_mem_gb() { # {{{1
    # """
    # Get total system memory in GB.
    # @note Updated 2021-05-26.
    #
    # - 1 GB / 1024 MB
    # - 1 MB / 1024 KB
    # - 1 KB / 1024 bytes
    #
    # Usage of 'int()' in awk rounds down.
    # """
    local awk denom mem
    [ "$#" -eq 0 ] || return 1
    awk='awk'
    if _koopa_is_macos
    then
        mem="$(sysctl -n hw.memsize)"
        denom=1073741824  # 1024^3; bytes
    else
        # shellcheck disable=SC2016
        mem="$("$awk" '/MemTotal/ {print $2}' '/proc/meminfo')"
        denom=1048576  # 1024^2; KB
    fi
    mem="$( \
        "$awk" -v denom="$denom" -v mem="$mem" \
        'BEGIN{ printf "%.0f\n", mem / denom }' \
    )"
    _koopa_print "$mem"
    return 0
}

_koopa_os_codename() { # {{{1
    # """
    # Operating system codename.
    # @note Updated 2021-06-02.
    # """
    [ "$#" -eq 0 ] || return 1
    if _koopa_is_debian_like
    then
        _koopa_debian_os_codename
    elif _koopa_is_macos
    then
        _koopa_macos_os_codename
    else
        return 1
    fi
    return 0
}

_koopa_os_id() { # {{{1
    # """
    # Operating system ID.
    # @note Updated 2021-05-21.
    #
    # Just return the OS platform ID (e.g. debian).
    # """
    local cut x
    [ "$#" -eq 0 ] || return 1
    cut='cut'
    x="$( \
        _koopa_os_string \
        | "$cut" -d '-' -f 1 \
    )"
    [ -n "$x" ] || return 1
    _koopa_print "$x"
    return 0
}

_koopa_os_string() { # {{{1
    # """
    # Operating system string.
    # @note Updated 2021-05-21.
    #
    # Alternatively, use 'hostnamectl'.
    # https://linuxize.com/post/how-to-check-linux-version/
    #
    # If we ever add Windows support, look for: cygwin, mingw32*, msys*.
    # """
    local awk id release_file string tr version
    [ "$#" -eq 0 ] || return 1
    if _koopa_is_macos
    then
        id='macos'
        version="$(_koopa_macos_version)"
        version="$(_koopa_major_minor_version "$version")"
    elif _koopa_is_linux
    then
        awk='awk'
        tr='tr'
        release_file='/etc/os-release'
        if [ -r "$release_file" ]
        then
            # shellcheck disable=SC2016
            id="$( \
                "$awk" -F= '$1=="ID" { print $2 ;}' "$release_file" \
                | "$tr" -d '"' \
            )"
            # Include the major release version.
            # shellcheck disable=SC2016
            version="$( \
                "$awk" -F= '$1=="VERSION_ID" { print $2 ;}' "$release_file" \
                | "$tr" -d '"'
            )"
            if [ -n "$version" ]
            then
                version="$(_koopa_major_version "$version")"
            else
                # This is the case for Arch Linux.
                version='rolling'
            fi
        else
            id='linux'
        fi
    fi
    [ -z "$id" ] && return 1
    string="$id"
    if [ -n "${version:-}" ]
    then
        string="${string}-${version}"
    fi
    _koopa_print "$string"
    return 0
}

_koopa_shell_name() { # {{{1
    # """
    # Current shell name.
    # @note Updated 2021-05-25.
    # """
    local shell str
    [ "$#" -eq 0 ] || return 1
    shell="$(_koopa_locate_shell)"
    str="$(basename "$shell")"
    [ -n "$str" ] || return 1
    _koopa_print "$str"
    return 0
}

_koopa_today() { # {{{1
    # """
    # Today string.
    # @note Updated 2021-05-26.
    # """
    local date str
    [ "$#" -eq 0 ] || return 1
    date='date'
    str="$("$date" '+%Y-%m-%d')"
    [ -n "$str" ] || return 1
    _koopa_print "$str"
    return 0
}

_koopa_user() { # {{{1
    # """
    # Current user name.
    # @note Updated 2020-06-30.
    #
    # Alternatively, can use 'whoami' here.
    # """
    [ "$#" -eq 0 ] || return 1
    __koopa_id -un
    return 0
}

_koopa_user_id() { # {{{1
    # """
    # Current user ID.
    # @note Updated 2020-04-16.
    # """
    [ "$#" -eq 0 ] || return 1
    __koopa_id -u
    return 0
}
