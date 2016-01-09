if [ $(uname) = "Darwin" ]; then
    function osx_show_all_files() {
        defaults write com.apple.finder AppleShowAllFiles 1
        killall Finder
    }
    function osx_hide_all_files() {
        defaults write com.apple.finder AppleShowAllFiles 0
        killall Finder
    }
fi

function remove_DS_Store_recursively() {
    find . -name ".DS_Store" -print -exec rm -rf {} \;
}
