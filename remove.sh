#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_LOCK" ] && umount_rootfs_all

rm -f "$ROOTFS_IMG" || fail

quit
