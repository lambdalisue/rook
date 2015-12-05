function static() {
    local PORT=$1
    if [[ -z $PORT ]]; then
        PORT=8000
    fi
    if type python3 > /dev/null 2>&1; then
        python3 -m http.server $PORT
    elif type python2 > /dev/null 2>&1; then
        python2 -m SimpleHTTPServer $PORT
    elif type python > /dev/null 2>&1; then
        local VERSION=$(python -c "import sys; print(sys.version_info.major)")
        if [[ "$VERSION" == "3" ]]; then
            python -m http.server $PORT
        else
            python -m SimpleHTTPServer $PORT
        fi
    else
        echo "'static' require python 2.x or 3.x but both is not installed."
        exit 1
    fi
}
