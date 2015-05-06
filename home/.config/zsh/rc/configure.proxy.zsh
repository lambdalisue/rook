# http://qiita.com/o_ame/items/b9991d1f86b23f4a184d
proxy="http://proxy.kuins.net:8080"

function set_proxy() {
    export http_proxy=$proxy
    export HTTP_PROXY=$proxy
    export https_proxy=$proxy
    export HTTPS_PROXY=$proxy
    export ftp_proxy=$proxy
    export FTP_PROXY=$proxy
    export no_proxy="127.0.0.1,localhost,192.168.0.0/24,10.238.0.0/24"
    export NO_PROXY=$no_proxy

    git config -f ~/.gitconfig.local http.proxy $proxy
    git config -f ~/.gitconfig.local https.proxy $proxy
    git config -f ~/.gitconfig.local url."https://".insteadOf git://
}

function unset_proxy() {
    unset http_proxy
    unset HTTP_PROXY
    unset https_proxy
    unset HTTPS_PROXY
    unset ftp_proxy
    unset FTP_PROXY
    unset no_proxy
    unset NO_PROXY

    git config -f ~/.gitconfig.local --unset http.proxy
    git config -f ~/.gitconfig.local --unset https.proxy
    git config -f ~/.gitconfig.local --unset url."https://".insteadOf
}
