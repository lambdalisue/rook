#
# A simple plugin management system for ZSH
#
# Author:   Alisue <lambdalisue@hashnote.net>
# License:  MIT License
#
function zundle_get_bundle_path() {
    local name=$1
    local bundle_root
    zstyle -s ":zundle:root" bundle bundle_root
    echo -en "${bundle_root}/${name}"
}
function zundle_get_config_path() {
    local name=$1
    local config_root
    zstyle -s ":zundle:root" config config_root
    echo -en "${config_root}/${name}.zsh"
}
function zundle_install() {
    local url=$1
    local name=$2
    # complement github url
    if [[ "$url" =~ "^[^\/]*\/[^\/]*$" ]]; then
        url="https://github.com/$1"
    fi
    # complement name from url
    if [[ "$name" == "" ]]; then
        name=${$(basename ${url})%.*}
    fi
    # confirm presence and download
    local bundle_path="$(zundle_get_bundle_path $name)"
    if [[ ! -d "${bundle_path}" ]]; then
        git clone ${url} ${bundle_path}
    fi
    zundle_configure $name
}
function zundle_update() {
    local bundle_root
    zstyle -s ":zundle:root" bundle bundle_root
    for bundle_path in $bundle_root/*; do
        git -C "$bundle_path" pull
    done
}
function zundle_configure() {
    local name=$1
    local config_path="$(zundle_get_config_path $name)"
    if [[ -f "${config_path}" ]]; then
        source ${config_path}
    fi
}

function() {
    zstyle ":zundle:root" bundle "${ZDOTDIR}/zundle/bundle"
    zstyle ":zundle:root" config "${ZDOTDIR}/zundle/config"
}
