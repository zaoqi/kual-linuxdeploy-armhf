#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_LOCK" ] || mount_rootfs_all

[ -f "$ROOTFS_DIR/etc/apk/repositories" ] && sed -i 's|https\?://[^/]*/alpine|http://mirrors.ustc.edu.cn/alpine|g' "$ROOTFS_DIR/etc/apk/repositories"

quit
