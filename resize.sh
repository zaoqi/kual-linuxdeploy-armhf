#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_LOCK" ] && umount_rootfs_all

resize_rootfs_interactive
