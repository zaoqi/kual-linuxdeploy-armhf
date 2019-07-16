#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_IMG" ] && fail "rootfs exist.Please remove it and continue."

install_tgz_rootfs "http://mirrors.ustc.edu.cn/ubuntu-cdimage/ubuntu-base/releases/19.04/release/ubuntu-base-19.04-base-armhf.tar.gz"

quit
