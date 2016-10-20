__perldig_find_module_version() {
    local name="$1"
    /usr/bin/env perl -M$name -e "print \$$name::VERSION . \"\n\""
}

__perldig_find_installed_modules() {
    local collect_modules="${XDG_CONFIG_HOME}/zsh/plugin/perldig/lib/collect-modules.pl"
    /usr/bin/env perl $collect_modules $@
}

perldig() {
  local commad=shift
  if [ -z $command ]; then
    echo "Usage: perldig <command> <options>"
    echo
    echo "COMMAND"
    echo "  version - Find a installed module version"
    echo "  list    - List installed modules"
    exit 1
  fi
  if [[ "$command" = "version" ]]; then
    __perldig_find_module_version $@
  elif [[ "$command" = "list" ]]; then
    __perldig_find_installed_modules $@
  fi
}

