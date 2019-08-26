
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

quit(){
    echo "Done. $*"
    echo "press enter to countinue."
    read
    exit 0
}

fail(){
    echo "Failed. $*"
    echo "press enter to countinue."
    read
    exit 1
}

cd "$(dirname "$0")" || fail

BIN="$(pwd)"
ROOTFS_DIR="$(pwd)/rootfs"
SWAP_IMG="$(pwd)/swap"
ROOTFS_IMG="$(pwd)/rootfs.img"
SWAP_LOCK="/tmp/kUaL_lInUx_sWaP_mOuNtEd"
ROOTFS_LOCK="/tmp/kUaL_lInUx_mOuNtEd"
INNER_TMP="/tmp/kUaL_lInUx"
ROOTFS_TYPE=unknown
cp rootfs.ext4.base tmp.test.fs.tmp || fail
mkdir -p tmp.test.fs.dir || fail
if [ -f fs.config ];then
    ROOTFS_TYPE="$(cat fs.config)"
elif mount -o loop tmp.test.fs.tmp tmp.test.fs.dir 2>/dev/null; then
    echo "This kernel support ext4."
    ROOTFS_TYPE=ext4
    echo ext4 > fs.config
else
    echo "This kernel doesn't support ext4."
    ROOTFS_TYPE=ext3
    echo ext3 > fs.config
fi
umount tmp.test.fs.tmp 2>/dev/null
umount tmp.test.fs.dir 2>/dev/null
rm -fr tmp.test.fs.tmp tmp.test.fs.dir 2>/dev/null

baseus(){
    echo "$*" | sed 's|^/mnt/us/|/mnt/base-us/|'
}

copy_etc_files(){
    [ -f "$ROOTFS_LOCK" ] || fail "rootfs is not mounted."
    cp /etc/hostname /etc/hostname /etc/hosts /etc/resolv.conf "$ROOTFS_DIR/etc"
}

mount_swap(){
    if [ ! -f "$SWAP_LOCK" ] && [ -f "$SWAP_IMG" ]; then
	touch "$SWAP_LOCK" || fail
	mkswap "$(baseus "$SWAP_IMG")" || fail "cannot mount swap."
	swapon "$(baseus "$SWAP_IMG")" || fail "cannot mount swap."
    fi
}
mount_rootfs_base(){
    [ -f "$ROOTFS_LOCK" ] && fail "rootfs mounted."
    touch "$ROOTFS_LOCK" || fail
    mkdir -p "$ROOTFS_DIR" || fail
    mount -o loop "$ROOTFS_IMG" "$ROOTFS_DIR" || fail "cannot mount rootfs."
    chmod 755 "$ROOTFS_DIR" || fail
}
mount_rootfs_all(){
    mount_rootfs_base
    mkdir -p "$INNER_TMP" || fail
    mount -o bind "$INNER_TMP" "$ROOTFS_DIR/tmp" || fail "cannot bind /tmp."
    chmod 777 "$ROOTFS_DIR/tmp" || fail
    for d in /dev /dev/pts /proc /sys; do
	mount -o bind "/$d" "$ROOTFS_DIR/$d" || fail "cannot bind $d"
    done
    chmod a+w /dev/shm
    mount_swap
}

umount_swap(){
    if [ -f "$SWAP_LOCK" ] ; then
	swapoff "$(baseus "$SWAP_IMG")" || fail "cannot unmount swap."
	rm "$SWAP_LOCK" || fail
    fi
}
umount_rootfs_all(){
    [ -f "$ROOTFS_LOCK" ] || fail "rootfs is not mounted."
    kill -9 $(lsof -t "$ROOTFS_DIR")
    for d in /dev/pts /dev /proc /sys /tmp; do
	umount "$ROOTFS_DIR/$d" 2>/dev/null
    done
    umount "$ROOTFS_DIR" || fail "cannot unmount rootfs."
    rm "$ROOTFS_LOCK" || fail
    umount_swap
}

remove_swap(){
    [ -f "$SWAP_LOCK" ] && umount_swap
    rm -f "$SWAP_IMG" || fail
}
make_swap_interactive(){
    remove_swap
    cp rootfs."$ROOTFS_TYPE".base "$SWAP_IMG" || fail
    echo "Please enter the size of swap file and press Enter (e.g. 1000M):"
    local SWAP_SIZE
    read SWAP_SIZE || fail "cannot read input."
    "$BIN"/resize2fs "$SWAP_IMG" "$SWAP_SIZE" || fail "cannot resize."
    mkswap "$SWAP_IMG"
    mount_swap
}
resize_rootfs_interactive(){
    [ -f "$ROOTFS_LOCK" ] && fail "rootfs mounted."
    echo "Please enter the rootfs size and press Enter (e.g. 1000M):"
    local ROOTFS_SIZE
    read ROOTFS_SIZE || fail "cannot read input."
    "$BIN"/resize2fs "$ROOTFS_IMG" "$ROOTFS_SIZE" || fail "cannot resize."
}

install_tgz_rootfs(){
    local ROOTFS_TGZ_URL="$1"
    [ -f "$ROOTFS_LOCK" ] && fail "rootfs mounted."
    rm -fr "$ROOTFS_IMG" || fail
    cp rootfs."$ROOTFS_TYPE".base "$ROOTFS_IMG" || fail
    resize_rootfs_interactive
    mount_rootfs_base
    curl "$ROOTFS_TGZ_URL" | tar -xvz -C "$ROOTFS_DIR" || fail "download and extract rootfs: failed."
    umount_rootfs_all
}

do_chroot(){
    [ -f "$ROOTFS_LOCK" ] || fail "rootfs is not mounted."
    copy_etc_files
    HOME=/root chroot "$ROOTFS_DIR" "$@"
}
