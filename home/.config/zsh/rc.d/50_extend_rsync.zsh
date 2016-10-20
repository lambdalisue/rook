rsync::push() {
    local PWD=$(pwd)
    local HOST=$1; shift
    if [[ -z $HOST ]]; then
        echo "Usage: rsync::push {host} [{rsync options}]"
        echo "  Push contents in the current working directory to {host}"
        return 1
    fi
    # Note:
    #   -e 'ssh -c arcfour' improve transfer speed but there is a security
    #   issue so it should not be used except in an intra network
    echo "rsync -e 'ssh -c arcfour' -az ${PWD}/ ${HOST}:${PWD}/ $@"
    rsync -e 'ssh -c arcfour' --rsync-path="mkdir -p ${PWD} && rsync" -az ${PWD}/ ${HOST}:${PWD}/ $@
}

rsync::pull() {
    local PWD=$(pwd)
    local HOST=$1; shift
    if [[ -z $HOST ]]; then
        echo "Usage: rsync::pull {host} [{rsync options}]"
        echo "  Pull contents in the current working directory to {host}"
        return 1
    fi
    # Note:
    #   -e 'ssh -c arcfour' improve transfer speed but there is a security
    #   issue so it should not be used except in an intra network
    echo "rsync -e 'ssh -c arcfour' -az ${HOST}:${PWD}/ ${PWD}/ $@"
    rsync -e 'ssh -c arcfour' -az ${HOST}:${PWD}/ ${PWD}/ $@
}
