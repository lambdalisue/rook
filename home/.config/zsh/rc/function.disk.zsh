function disk_get_size() {
    local disk="$1"
    local stdout="$(sudo fdisk -l $disk)"
    local bytes="$(sudo fdisk -l $disk \
        | grep -eo \"Disk $disk:\" \
        | grep -eo \"\([0-9]+\) bytes\")"
    echo $bytes
}
