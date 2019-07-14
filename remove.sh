#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_LOCK" ] && umount_rootfs_all

rm -fr "$ROOTFS_IMG" || fail
