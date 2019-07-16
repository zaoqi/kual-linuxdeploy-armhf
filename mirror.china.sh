#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_LOCK" ] || mount_rootfs_all

[ -f "$ROOTFS_DIR/etc/apk/repositories" ] && sed -i 's|https\?://[^/]*/alpine|http://mirrors.ustc.edu.cn/alpine|g' "$ROOTFS_DIR/etc/apk/repositories"

[ -f "$ROOTFS_DIR/etc/apt/sources.list" ] && sed -i 's|https\?://[^/]*/ubuntu-ports|http://mirrors.ustc.edu.cn/ubuntu-ports|g' "$ROOTFS_DIR/etc/apt/sources.list"

quit
