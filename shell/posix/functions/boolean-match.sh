#!/bin/sh

_koopa_str_match() { # {{{1
    # """
    # Does the input match a fixed string?
    # @note Updated 2020-05-05.
    #
    # Usage of '-q' flag can cause an exit trap in 'set -e' mode.
    # Redirecting output to '/dev/null' works more reliably.
    #
    # @seealso
    # - https://bugzilla.redhat.com/show_bug.cgi?id=1589997
    # - https://unix.stackexchange.com/questions/233987
    #
    # @examples
    # koopa::str_match STRING PATTERN
    # echo STRING | koopa::str_match PATTERN
    # """
    # shellcheck disable=SC2039
    local string pattern
    _koopa_is_installed grep || return 1
    if [ "$#" -eq 2 ]
    then
        # Standard input.
        # Note that we're allowing empty string input here.
        string="${1:-}"
        pattern="${2:?}"
    elif [ "$#" -eq 1 ]
    then
        # Piped input using stdin.
        pattern="${1:?}"
        shift 1
        # Handle string with line breaks '\n'.
        # shellcheck disable=SC2039
        read -r -d '' string
    else
        return 1
    fi
    echo "$string" | grep -Fq "$pattern" >/dev/null
}

_koopa_str_match_posix() { # {{{1
    # """
    # Evaluate whether a string contains a desired value.
    # @note Updated 2020-04-29.
    #
    # POSIX-compliant function that mimics grepl functionality.
    #
    # @seealso grepl in R.
    # """
    test "${1#*$2}" != "$1"
}

_koopa_str_match_regex() { # {{{1
    # """
    # Does the input match a regular expression?
    # @note Updated 2020-05-05.
    # """
    # shellcheck disable=SC2039
    local string pattern
    _koopa_is_installed grep || return 1
    if [ "$#" -eq 2 ]
    then
        # Standard input.
        # Note that we're allowing empty string input here.
        string="${1:-}"
        pattern="${2:?}"
    elif [ "$#" -eq 1 ]
    then
        # Piped input using stdin.
        pattern="${1:?}"
        shift 1
        # Handle string with line breaks '\n'.
        # shellcheck disable=SC2039
        read -r -d '' string
    else
        return 1
    fi
    echo "$string" | grep -Eq "$pattern" >/dev/null
}
