# automatically call ls in chpwd
function chpwd() {
    emulate -L zsh
    ls -C
}
