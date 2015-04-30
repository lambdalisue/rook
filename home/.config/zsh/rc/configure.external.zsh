if [ ! -d "${ZDOTDIR}/bundle" ]; then
    mkdir -p "${ZDOTDIR}/bundle"
fi

if [ ! -d "${ZDOTDIR}/bundle/z" ]; then
    git clone "https://github.com/rupa/z" "${ZDOTDIR}/bundle/z"
fi
