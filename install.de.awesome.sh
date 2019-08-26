#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_LOCK" ] || mount_rootfs_all

dotfile_version=bde80e433f3e5f83e31a9af14445f569eb319080

if [ -f "$ROOTFS_DIR/etc/apk/repositories" ]; then
    [ -d "$ROOTFS_DIR/home/kindle" ] || fail "USER 'kindle' does not exist"
    echo 'http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing' > "$ROOTFS_DIR/etc/apk/repositories"
    do_chroot /bin/sh -c 'apk add xorg-server-xephyr awesome lxterminal xvkbd' || fail "cannot install packages."
elif [ -f "$ROOTFS_DIR/etc/apt/sources.list" ]; then
    do_chroot /bin/sh -c 'apt update && apt install -y xserver-xephyr awesome lxterminal xvkbd' || fail "cannot install packages."
else
    fail "Unsupport system."
fi

mkdir -p "$ROOTFS_DIR/usr/share/applications/"
cat > "$ROOTFS_DIR/usr/share/applications/stopx.desktop" << 'EOF'
[Desktop Entry]
Categories=Network;InstantMessaging;GTK;GNOME;
Name=Stop X
Version=1.0
Exec=killall Xephyr xfce4-session
Terminal=false
Type=Application
EOF
chmod +x "$ROOTFS_DIR/usr/share/applications/stopx.desktop"

(curl -L "https://codeload.github.com/zaoqi/AwesomeTouch/tar.gz/$dotfile_version" | tar -xzv -C "$ROOTFS_DIR/home/kindle" &&
  mkdir -p "$ROOTFS_DIR/home/kindle/.config" &&
  rm -fr "$ROOTFS_DIR/home/kindle/.config/awesome" &&
  mv "$ROOTFS_DIR/home/kindle/AwesomeTouch-$dotfile_version" "$ROOTFS_DIR/home/kindle/.config/awesome") ||
  fail "cannot download .config"

quit
