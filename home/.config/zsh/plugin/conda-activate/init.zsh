#!/usr/bin/env zsh

conda-activate() {
  if ! which jq >/dev/null 2>&1; then
    echo "'jq' is not found. Install it and retry." >&2
    return 1
  fi

  local DEFAULT_PREFIX=$(conda info --json | jq -r '.default_prefix')
  source "${DEFAULT_PREFIX}/bin/activate" $@
}

_conda-activate() {
  if ! which conda >/dev/null 2>&1; then
    return 1
  fi
  local result=$(conda info -e 2>/dev/null)
  if [[ $result == '' ]]; then
    return 1
  else
    envs=(${(@f)"$(echo "$result" | sed '/^#/d' | sed '/^$/d' | awk '{print $1}')}"})
    _values 'envs' $envs
  fi
}

compdef _conda-activate conda-activate
