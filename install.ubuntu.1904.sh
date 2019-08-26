#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_IMG" ] && fail "rootfs exist.Please remove it and continue."

get_rootfs_tgz_url(){
    echo "http://mirrors.ustc.edu.cn/ubuntu-cdimage/ubuntu-base/releases/19.04/release/ubuntu-base-19.04-base-armhf.tar.gz"
}

install_tgz_rootfs "get_rootfs_tgz_url"

quit
