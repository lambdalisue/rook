function vim_symlink_cwd_to_bundle() {
    local name="$(basename $(pwd))"
    if [ -d "$HOME/.vim/bundle/local/$name" ]; then
        /bin/rm -r $HOME/.vim/bundle/local/$name
    fi
    ln -s $(pwd) $HOME/.vim/bundle/local/$name
}
