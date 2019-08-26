#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_LOCK" ] || mount_rootfs_all

dotfile_version=13b3551f6a76e5a53d90b0f613b50a4efcc57a8c

if [ -f "$ROOTFS_DIR/etc/apk/repositories" ]; then
    [ -d "$ROOTFS_DIR/home/kindle" ] || fail "USER 'kindle' does not exist"
    echo 'http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing' > "$ROOTFS_DIR/etc/apk/repositories"
    do_chroot /bin/sh -c 'apk add xorg-server-xephyr xfce4 xfce4-terminal xfce4-battery-plugin gnome-themes-extra onboard xdotool' || fail "cannot install packages."
elif [ -f "$ROOTFS_DIR/etc/apt/sources.list" ]; then
    do_chroot /bin/sh -c 'apt update && apt install -y xserver-xephyr xfce4 xfce4-terminal xfce4-battery-plugin gnome-themes-extra onboard xdotool' || fail "cannot install packages."
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

(curl -L "https://codeload.github.com/schuhumi/alpine_kindle_dotfiles/tar.gz/$dotfile_version" | tar -xzv -C "$ROOTFS_DIR/home/kindle" &&
  cp -rv "$ROOTFS_DIR/home/kindle/alpine_kindle_dotfiles-$dotfile_version/.config/" "$ROOTFS_DIR/home/kindle" &&
  rm -fr "$ROOTFS_DIR/home/kindle/alpine_kindle_dotfiles-$dotfile_version/") ||
  fail "cannot download .config"

quit
