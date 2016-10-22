zplug "zplug/zplug"

# The platinum searcher: pt
zplug "monochromegane/the_platinum_searcher", \
  as:command, \
  from:gh-r, \
  rename-to:pt

# Command-line JSON processor
zplug "stedolan/jq", \
  as:command, \
  from:gh-r

# Remote repository management tool
zplug "motemen/ghq", \
  as:command, \
  from:gh-r, \
  rename-to:ghq

# GitHub integration CLI tool
zplug "github/hub", \
  as:command, \
  from:gh-r

zplug "glidenote/hub-zsh-completion", \
  on:"github/hub"

# Command-line fuzzy finder
zplug "junegunn/fzf-bin", \
  as:command, \
  from:gh-r, \
  rename-to:fzf

# Command-line Trash-box interface
zplug "b4b4r07/gomi", \
  as:command, \
  from:gh-r

# Extract any archive with 'extract' command
zplug "plugins/extract", \
  from:oh-my-zsh

# Improve 'cd' interface
zplug "b4b4r07/enhancd", \
  use:init.sh

# Closs-platform clipboard
# - clipcopy
# - clippaste
zplug "lib/clipboard", \
  from:oh-my-zsh

# Add extra zsh-completions
zplug "zsh-users/zsh-completions"

# zsh-syntax-highlighting requires to be loaded AFTER
# 'compinit' command and sourcing other plugins
# Plugins with nice >= 10 are loaded AFTER 'compinit'
zplug "zsh-users/zsh-syntax-highlighting", \
  nice:10

# zsh-history-substring-search requires to be loaded
# AFTER zsh-syntax-highlighting
zplug "zsh-users/zsh-history-substring-search", \
  nice:11

# Add static HTTP serve command
# - serve
zplug "~/.config/zsh/plugin/serve", \
  from:local, \
  use:init.zsh

# Add perl dignostic command
# - perldig
zplug "~/.config/zsh/plugin/perldig", \
  from:local, \
  use:init.zsh
