#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_IMG" ] && fail "rootfs exist.Please remove it and continue."

install_alpine_rootfs

quit
