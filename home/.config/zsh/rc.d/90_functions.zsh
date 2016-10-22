zsh_remove_cache() {
  command rm ${ZDOTDIR}/.zcompdump
  command rm ${ZDOTDIR}/*.zwc
  command rm ${ZDOTDIR}/rc.d/*.zwc
}
