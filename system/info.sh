#!/usr/bin/env bash

# Show koopa installation information in a box.

quiet_command() {
    command -v "$1" 2>/dev/null
}

# Require that koopa is activate and exported to PATH.
if [ -z ${KOOPA_PLATFORM+x} ]
then
    echo "koopa is not correctly activated."
    exit 1
fi

array=()
array+=("koopa v${KOOPA_VERSION} (${KOOPA_DATE})")
array+=("https://github.com/steinbaugh/koopa")

# Alternatively, can use `$( uname -mnrs )`.
array+=("System: $KOOPA_PLATFORM")

array+=("Shell: $SHELL")

aspera="$( quiet_command asperaconnect )"
if [[ -f "$aspera" ]]; then
    array+=("Aspera: ${aspera}")
fi
unset -v aspera

bcbio="$( quiet_command bcbio_nextgen.py )"
if [[ -f "$bcbio" ]]; then
    array+=("bcbio: ${bcbio}")
fi
unset -v bcbio

conda="$( quiet_command conda )"
if [[ -f "${conda}" ]]; then
    array+=("Conda: ${conda}")
fi
unset -v conda

git="$( quiet_command git )"
if [[ -f "$git" ]]; then
    array+=("Git: ${git}")
fi
unset -v git

gpg="$( quiet_command gpg )"
if [[ -f "$gpg" ]]; then
    array+=("GPG: ${gpg}")
fi
unset -v gpg

openssl="$( quiet_command openssl )"
if [[ -f "$openssl" ]]; then
    array+=("OpenSSL: ${openssl}")
fi
unset -v openssl

perl="$( quiet_command perl )"
if [[ -f "$perl" ]]; then
    array+=("Perl: ${perl}")
fi
unset -v perl

python="$( quiet_command python )"
if [[ -f "${python}" ]]; then
    array+=("Python: ${python}")
fi
unset -v python

r="$( quiet_command R )"
if [[ -f "$r" ]]; then
    array+=("R: ${r}")
fi
unset -v r

ruby="$( quiet_command ruby )"
if [[ -f "$ruby" ]]; then
    array+=("Ruby: ${ruby}")
fi
unset -v ruby

# Using unicode box drawings here.
# Note that we're truncating lines inside the box to 68 characters.
barpad="$( printf "━%.0s" {1..70} )"
printf "\n  %s%s%s  \n"  "┏" "$barpad" "┓"
for i in "${array[@]}"; do
    printf "  ┃ %-68s ┃  \n"  "${i::68}"
done
printf "  %s%s%s  \n\n"  "┗" "$barpad" "┛"

unset -v array barpad
