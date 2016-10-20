zplug "zplug/zplug"

zplug "~/.config/zsh/plugin/serve", \
  from:local, \
  use:init.sh

zplug "~/.config/zsh/plugin/perldig", \
  from:local, \
  use:init.sh

zplug "b4b4r07/zsh-gomi", \
  as:command, \
  use:bin/gomi

zplug "mrowa44/emojify", \
  as:command

zplug "monochromegane/the_platinum_searcher", \
  as:command, \
  from:gh-r, \
  rename-to:"pt"

zplug "stedolan/jq", \
  as:command, \
  from:gh-r

zplug "peco/peco", \
  as:command, \
  from:gh-r

zplug "motemen/ghq", \
  as:command, \
  from:gh-r, \
  rename-to:ghq

zplug "b4b4r07/ls.zsh", \
  as:command, \
  use:bin/ls

zplug "plugins/extract", \
  from:oh-my-zsh

zplug "b4b4r07/emoji-cli", \
  if:'(( $+commands[jq] ))', \
  on:"peco/peco"

zplug "b4b4r07/enhancd", \
  use:init.sh

zplug "glidenote/hub-zsh-completion"

zplug "b4b4r07/zsh-vimode-visual", \
  use:"*.sh"

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-history-substring-search"

zplug "zsh-users/zsh-syntax-highlighting"
