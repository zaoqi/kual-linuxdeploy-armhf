#!/bin/sh

. "$(dirname "$0")"/lib.sh

[ -f "$ROOTFS_IMG" ] && fail "rootfs exist.Please remove it and continue."

get_rootfs_tgz_filename(){
    curl http://dl-cdn.alpinelinux.org/alpine/edge/releases/armhf/ |
	grep '^<a.*"alpine-minirootfs-[0-9]*-armhf\.tar\.gz"' |
	sed 's|^<a *href="\(.*\)">.*</a>.*$|\1|' |
	sort |
	tail -1
}
get_rootfs_tgz_url(){
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/releases/armhf/$(get_rootfs_tgz_filename)"
}

install_tgz_rootfs "get_rootfs_tgz_url"

quit
