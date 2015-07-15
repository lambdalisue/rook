function askYesOrNo() {
    while true ; do
        echo "$1 (y/n)?"
        read answer
        case $answer in
            [yY] | [yY]es | YES )
                return 0;;
            [nN] | [nN]o | NO )
                return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

function disk_get_size() {
    local disk="$1"
    local bytes="$(sudo fdisk -l $disk \
        | grep -e "Disk $disk:" \
        | grep -o "[0-9]\+ bytes" \
        )"
    echo $bytes
}

function disk_dd() {
    local src="$1"
    local dst="$2"
    echo "\033[1mdisk_dd {src} [{dst=~/disk.dd}] [{dd_option}, ...]\033[0m"
    echo
    echo "Copy an entire disk image into a single file/disk via dd & pv"
    echo
    echo "                            \033[0;31mWARNING\033[0m"
    echo "  This function may CRASH YOUR COMPUTER and may result into DATA"
    echo "                 LOSS if not executed with care"
    echo
    echo "                            \033[0;31mWARNING\033[0m"
    echo "             DO NOT USE disk_dd to rescue the disk."
    echo "          Use ddrescue (GNU version) for that purpose."
    echo "                (sudo apt-get install gddrescue)"
    echo
    if [[ -z "$src" ]]; then
        echo "\033[0;31mNo {src} is specified. Exit.\033[0m"
        return 1
    else
        shift
    fi
    if [[ -z "$dst" ]]; then
        local dst="$HOME/disk.dd"
    else
        shift
    fi
    if [[ -f "$dst" ]]; then
        echo "\033[0;31mA file $dst exists. Please remove the file manually first.\033[0m"
        return 1
    fi
    local size=$(disk_get_size $src | awk '{print $1}')
    echo "The following command will be performed."
    echo
    echo "  \033[0;37msudo dd if=$src conv=noerror,sync $@ | pv -tpreb -s $size | dd of=$dst\033[0m"
    echo
    if askYesOrNo "Are you sure to continue"; then
        sudo dd if=$src conv=noerror,sync $@ | pv -tpreb -s $size | dd of=$dst
    fi
}
