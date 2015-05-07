#!/usr/bin/env zsh
#
# txt2html via pandoc
#
txt2html_root="${ZDOTDIR}/tools/txt2html"

txt2html() {
    if ! type pandoc > /dev/null 2>&1; then
        echo "You need to install pandoc to enable this function"
        return 1
    fi
    $txt2html_root/txt2html $@ -t html5
}
txt2pdf() {
    if ! type pandoc > /dev/null 2>&1; then
        echo "You need to install pandoc to enable this function"
        return 1
    fi
    INFILE="$1"
    shift
    $txt2html_root/txt2html $INFILE -t html5 --self-contained | wkhtmltopdf --print-media-type - $@ 
}
