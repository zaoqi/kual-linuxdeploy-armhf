#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_LOCK" ] || mount_rootfs_all

dotfile_version=13b3551f6a76e5a53d90b0f613b50a4efcc57a8c

if [ -f "$ROOTFS_DIR/etc/apk/repositories" ]; then
    [ -d "$ROOTFS_DIR/home/kindle" ] || fail "USER 'kindle' does not exist"
    echo 'http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing' > "$ROOTFS_DIR/etc/apk/repositories"
    do_chroot /bin/sh -c 'apk add xorg-server-xephyr xfce4 xfce4-terminal xfce4-battery-plugin gnome-themes-extra onboard xwininfo xdotool' || fail "cannot install packages."
elif [ -f "$ROOTFS_DIR/etc/apt/sources.list" ]; then
    fail "Unsupport system: Ubuntu"
else
    fail "Unsupport system."
fi

(curl -L "https://codeload.github.com/schuhumi/alpine_kindle_dotfiles/tar.gz/$dotfile_version" | tar -xzv -C "$ROOTFS_DIR/home/kindle" &&
  mv "$ROOTFS_DIR/home/kindle/alpine_kindle_dotfiles-$dotfile_version/.config/" "$ROOTFS_DIR/home/kindle" &&
  rm -fr "$ROOTFS_DIR/home/kindle/alpine_kindle_dotfiles-$dotfile_version/") ||
  fail "cannot download .config"

quit
