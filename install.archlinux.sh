#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_IMG" ] && fail "rootfs exist.Please remove it and continue."

mirror=http://os.archlinuxarm.org/os

get_rootfs_tgz_url(){
    echo "$mirror/ArchLinuxARM-armv7-latest.tar.gz"
}

install_tgz_rootfs "get_rootfs_tgz_url"

quit
