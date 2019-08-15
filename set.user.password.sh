#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_LOCK" ] || mount_rootfs_all

do_chroot /bin/sh -c 'passwd kindle' || fail "cannot change password."

quit
