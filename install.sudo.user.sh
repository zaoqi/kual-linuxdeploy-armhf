#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_LOCK" ] || mount_rootfs_all

if [ -f "$ROOTFS_DIR/etc/apk/repositories" ]; then
    do_chroot apk add sudo || fail "cannot install sudo."
elif [ -f "$ROOTFS_DIR/etc/apt/sources.list" ]; then
    do_chroot apt update || fail "cannot install sudo."
    do_chroot apt install -y sudo || fail "cannot install sudo."
else
    fail "Unsupport system."
fi

do_chroot adduser -D kindle || fail "cannot add user."
echo "kindle ALL=(ALL) ALL" > "$ROOTFS_DIR/etc/sudoers.d/kindle" || fail
chmod 440 "$ROOTFS_DIR/etc/sudoers.d/kindle" || fail
do_chroot passwd kindle || fail "cannot change password.(You can safely change password later.)"

quit
