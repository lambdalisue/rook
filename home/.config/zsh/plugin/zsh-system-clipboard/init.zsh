#
# Connect kill buffer of zsh to system clipboard via clipcopy/clippaste
#
# Author:  lambdalisue <lambdalisue@hashnote.net>
# License: MIT
#

# Reference {{{
#
# bindkey -M emacs : emacs
# bindkey -M vicmd : vicmd
# bindkey -M viins : viins
#
# mapping-name (emacs) (vicmd) (viins)
#     Description
#
# backward-kill-line
#     Kill from the beginning of the line to the cursor position. 
# backward-kill-word (^W ESC-^H ESC-^?) (unbound) (unbound)
#     Kill the word behind the cursor. 
# copy-region-as-kill (ESC-W ESC-w) (unbound) (unbound)
#     Copy the area from the cursor to the mark to the kill buffer. 
# copy-prev-word (ESC-^_) (unbound) (unbound)
#     Duplicate the word behind the cursor. 
# kill-word (ESC-D ESC-d) (unbound) (unbound)
#     Kill the current word. 
# kill-line (^K) (unbound) (unbound)
#     Kill from the cursor to the end of the line. 
# kill-region
#     Kill from the cursor to the mark. 
# kill-buffer (^X^K) (unbound) (unbound)
#     Kill the entire buffer. 
# kill-whole-line (^U) (unbound) (unbound)
#     Kill the current line. 
# yank (^Y) (unbound) (unbound)
#     Insert the contents of the kill buffer at the cursor position. 
#
# vi-backward-kill-word (unbound) (unbound) (^W)
#     Kill the word behind the cursor, without going past the point where insert mode was last entered. 
# vi-kill-line (unbound) (unbound) (^U)
#     Kill from the cursor back to wherever insert mode was last entered. 
# vi-kill-eol (unbound) (D) (unbound)
#     Kill from the cursor to the end of the line. 
# vi-put-before (unbound) (P) (unbound)
#     Insert the contents of the kill buffer before the cursor. If the kill buffer contains a sequence of lines (as opposed to characters), paste it above the current line. 
# vi-put-after (unbound) (p) (unbound)
#     Insert the contents of the kill buffer after the cursor. If the kill buffer contains a sequence of lines (as opposed to characters), paste it below the current line. 
# vi-yank (unbound) (y) (unbound)
#     Read a movement command from the keyboard, and copy the region from the cursor position to the endpoint of the movement into the kill buffer. If the command is vi-yank, copy the current line. 
# vi-yank-whole-line (unbound) (Y) (unbound)
#     Copy the current line into the kill buffer. 
# vi-yank-eol
#     Copy the region from the cursor position to the end of the line into the kill buffer. Arguably, this is what Y should do in vi, but it isn't what it actually does. 
#
# http://bolyai.cs.elte.hu/zsh-manual/zsh_14.html
# }}}

__has() {
  which "$1" >/dev/null 2>&1
}

# https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/clipboard.zsh
if __has 'clipcopy'; then
  alias __clipboard_copy=clipcopy
  alias __clipboard_paste=clippaste
elif __has 'pbcopy'; then
  alias __clipboard_copy=pbcopy
  alias __clipboard_paste=pbpaste
elif __has 'xsel'; then
  alias __clipboard_copy='xsel --input'
  alias __clipboard_paste='xsel --out'
elif __has 'xclip'; then
  alias __clipboard_copy='xclip -in -selection clipboard'
  alias __clipboard_paste='xclip -out -selection clipboard'
else
  __clipboard_copy() {}
  __clipboard_paste() {}
fi

# Emacs {{{
x-backward-kill-line() {
  zle backward-kill-line
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-backward-kill-line

x-backward-kill-word() {
  zle backward-kill-word
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-backward-kill-word
bindkey -M emacs "^W"   x-backward-kill-word
bindkey -M emacs "\e^H" x-backward-kill-word
bindkey -M emacs "\e^?" x-backward-kill-word

x-copy-region-as-kill () {
  zle copy-region-as-kill
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-copy-region-as-kill
bindkey -M emacs '\eW' x-copy-region-as-kill
bindkey -M emacs '\ew' x-copy-region-as-kill

x-copy-prev-word () {
  zle copy-prev-word
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-copy-prev-word
bindkey -M emacs '\e^_' x-copy-prev-word

x-kill-word() {
  zle kill-word
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-kill-word
bindkey -M emacs "\eD" x-kill-word
bindkey -M emacs "\ed" x-kill-word

x-kill-line() {
  zle kill-line
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-kill-line
bindkey -M emacs "^K" x-kill-line

x-kill-region() {
  zle kill-region
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-kill-region

x-kill-buffer() {
  zle kill-buffer
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-kill-buffer
bindkey -M emacs "^X^K" x-kill-line

x-kill-whole-line() {
  zle kill-whole-line
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-kill-whole-line
bindkey -M emacs "^U" x-kill-whole-line

x-yank () {
  CUTBUFFER=$(__clipboard_paste)
  zle yank
}
zle -N x-yank
bindkey -M emacs "^Y" x-yank
# }}}

# Vi {{{
x-vi-backward-kill-word() {
  zle vi-backward-kill-word
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-vi-backward-kill-word
bindkey -M viins "^W" x-vi-backward-kill-word

x-vi-kill-line() {
  zle vi-kill-line
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-vi-kill-line
bindkey -M viins "^U" x-vi-kill-line

x-vi-kill-eol() {
  zle vi-kill-eol
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-vi-kill-eol
bindkey -M vicmd "D" x-vi-kill-eol

x-vi-put-before() {
  CUTBUFFER=$(__clipboard_paste)
  zle vi-put-before
}
zle -N x-vi-put-before
bindkey -M vicmd 'P' x-vi-put-before

x-vi-put-after() {
  CUTBUFFER=$(__clipboard_paste)
  zle vi-put-after
}
zle -N x-vi-put-after
bindkey -M vicmd 'p' x-vi-put-after

x-vi-yank() {
  zle vi-yank
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-vi-yank
bindkey -M vicmd 'y' x-vi-yank

x-vi-yank-whole-line() {
  zle vi-yank-whole-line
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-vi-yank-whole-line
bindkey -M vicmd 'Y' x-vi-yank-whole-line

x-vi-yank-eol() {
  zle vi-yank-eol
  print -rn $CUTBUFFER | __clipboard_copy
}
zle -N x-vi-yank-eol
# }}}
