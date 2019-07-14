
echo "
    chroot for modern Kindle
    Copyright (C) 2019  zaoqi

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
"

cd "$(dirname "$0")"

fail(){
    echo "Failed. $*"
    echo "press enter to countinue."
    read
    exit 1
}

BIN="$(pwd)"
ROOTFS_DIR="$(pwd)/rootfs"
ROOTFS_IMG="$(pwd)/rootfs.img"
ROOTFS_TYPE=ext3
ROOTFS_LOCK="/tmp/kUaL_lInUx_mOuNtEd"
INNER_TMP="/tmp/kUaL_lInUx"
mkdir -p tmp.testext4
cp rootfs.ext4.base tmp.testext4.img || fail
if mount -o loop tmp.testext4.img tmp.testext4; then
    echo This kernel support ext4.
    ROOTFS_TYPE=ext4
else
    mkdir -p tmp.testext3
    cp rootfs.ext3.base tmp.testext3.img || fail
    mount -o loop tmp.testext3.img tmp.testext3 || fail "This kernel doesn't support ext4 and ext3."
    echo This kernel support ext3.
    ROOTFS_TYPE=ext3
fi
umount tmp.testext4
umount tmp.testext3
rm -fr tmp.*

get_rootfs_tgz_filename(){
    curl http://dl-cdn.alpinelinux.org/alpine/edge/releases/armhf/ |
	grep '^<a.*"alpine-minirootfs-[0-9]*-armhf\.tar\.gz"' |
	sed 's|^<a *href="\(.*\)">.*</a>.*$|\1|' |
	sort |
	tail -1
}
get_rootfs_tgz_url(){
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/releases/armhf/$(get_rootfs_filename)"
}

mount_rootfs_base(){
    [ -f "$ROOTFS_LOCK" ] && fail "rootfs mounted."
    touch "$ROOTFS_LOCK" || fail
    mkdir -p "$ROOTFS_DIR" || fail
    mount -o loop "$ROOTFS_IMG" "$ROOTFS_DIR" || fail "cannot mount rootfs."
}

umount_rootfs_all(){
    [ -f "$ROOTFS_LOCK" ] || fail "rootfs is not mounted."
    for d in /dev /dev/pts /proc /sys /tmp; do
	umount "$ROOTFS_DIR/$d"
    done
    umount "$ROOTFS_DIR" || fail "cannot unmount rootfs."
    rm "$ROOTFS_LOCK" || fail
}

resize_rootfs_interactive(){
    [ -f "$ROOTFS_LOCK" ] && fail "rootfs mounted."
    echo "Please enter the rootfs size and press Enter (e.g. 1000M):"
    if read ROOTFS_SIZE && [ -n "$ROOTFS_SIZE" ]; then
	resize2fs "$ROOTFS_IMG" "$ROOTFS_SIZE" || fail "cannot resize."
    else
	resize2fs "$ROOTFS_IMG" 512M || fail "cannot resize."
    fi
}

install_rootfs(){
    [ -f "$ROOTFS_LOCK" ] && fail "rootfs mounted."
    rm -fr "$ROOTFS_IMG" || fail
    cp rootfs."$ROOTFS_TYPE".base "$ROOTFS_IMG" || fail
    resize_rootfs_interactive
    mount_rootfs_base
    curl "$(get_rootfs_tgz_url)" | tar -xvz -C "$ROOTFS_DIR" || fail "download and extract rootfs: failed."
    umount_rootfs_all
}

mount_rootfs_all(){
    mount_rootfs_base
    mkdir -p "$INNER_TMP" || fail
    mount -o bind "$INNER_TMP" "$ROOTFS_DIR/tmp" || fail "cannot bind /tmp."
    for d in /dev /dev/pts /proc /sys; do
	mount -o bind "/$d" "$ROOTFS_DIR/$d" || fail "cannot bind $d"
    done
}

do_chroot(){
    [ -f "$ROOTFS_LOCK" ] || fail "rootfs is not mounted."
    HOME=/root chroot "$ROOTFS_DIR" "$@"
}
