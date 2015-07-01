function vim_symlink_cwd_to_bundle() {
    local name="$(basename $(pwd))"
    if [ -d "$HOME/.vim/bundle/$name" ]; then
        rm -r $HOME/.vim/bundle/$name
    fi
    ln -s $(pwd) $HOME/.vim/bundle/$name
}
