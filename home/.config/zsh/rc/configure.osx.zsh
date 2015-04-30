if [ $(uname) = "Darwin" ]; then
    function show_all_files() {
        defaults write com.apple.finder AppleShowAllFiles 1
        killall Finder
    }
    function hide_all_files() {
        defaults write com.apple.finder AppleShowAllFiles 0
        killall Finder
    }
fi
