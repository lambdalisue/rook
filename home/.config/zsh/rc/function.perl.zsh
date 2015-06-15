function perl_find_module_version() {
    local name="$1"
    perl -M$name -e "print \$$name::VERSION . '\n'"
}
function perl_find_installed_modules() {
    local collect_modules="${ZDOTDIR}/tools/perl/collect-modules.pl"
    $collect_modules $@
}
