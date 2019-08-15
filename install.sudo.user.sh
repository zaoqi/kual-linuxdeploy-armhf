#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_LOCK" ] || mount_rootfs_all

if [ -f "$ROOTFS_DIR/etc/apk/repositories" ]; then
    do_chroot /bin/sh -c 'apk add sudo' || fail "cannot install sudo."
    do_chroot /bin/busybox adduser -D kindle || fail "cannot add user."
elif [ -f "$ROOTFS_DIR/etc/apt/sources.list" ]; then
    do_chroot /bin/sh -c 'apt update' || fail "cannot install sudo."
    do_chroot /bin/sh -c 'apt install -y sudo' || fail "cannot install sudo."
    do_chroot /bin/sh -c 'useradd -m kindle' || fail "cannot add user."
else
    fail "Unsupport system."
fi

echo "kindle ALL=(ALL) ALL" > "$ROOTFS_DIR/etc/sudoers.d/kindle" || fail
chmod 440 "$ROOTFS_DIR/etc/sudoers.d/kindle" || fail
do_chroot /bin/sh -c 'passwd kindle' || fail "cannot change password.(You can safely change password later.)"

quit
