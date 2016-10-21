zplug "zplug/zplug"

# Emoji input support tool
zplug "mrowa44/emojify", \
  as:command

# The platinum searcher: pt
zplug "monochromegane/the_platinum_searcher", \
  as:command, \
  from:gh-r

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

zplug "glidenote/hub-zsh-completion"

zplug "b4b4r07/zsh-vimode-visual", \
  use:"*.sh"

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-history-substring-search"

zplug "zsh-users/zsh-syntax-highlighting"

zplug "~/.config/zsh/plugin/serve", \
  from:local, \
  use:init.zsh

zplug "~/.config/zsh/plugin/perldig", \
  from:local, \
  use:init.zsh
