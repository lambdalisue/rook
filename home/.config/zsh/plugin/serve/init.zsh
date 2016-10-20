__serve::python() {
    local port=$1
    local version=$(python -c "import sys; print(sys.version_info.major)")
    if [[ "$version" == "3" ]]; then
        python -m http.server $port
    else
        python -m SimpleHTTPServer $port
    fi
}

__serve::python2() {
    local port=$1
    python2 -m SimpleHTTPServer $port
}

__serve::python3() {
    local port=$1
    python3 -m http.server $port
}

__serve::main() {
    local port=$1
    if [[ -z $port ]]; then
        port=8000
    fi
    if type python3 > /dev/null 2>&1; then
      __serve::python3 $port
    elif type python2 > /dev/null 2>&1; then
      __serve::python2 $port
    elif type python > /dev/null 2>&1; then
      __serve::python $port
    else
        echo "'$0' requires python, python2 or python3 but none is found."
        return 1
    fi
}

eval "alias ${SERVE_COMMAND:-serve}=__serve::main"

