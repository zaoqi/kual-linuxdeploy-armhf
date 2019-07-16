all: kual-linuxdeploy-armhf.zip

rootfs.ext3.base:
	dd if=/dev/zero of=rootfs.ext3.base bs=10M count=1
	mkfs.ext3 rootfs.ext3.base
	resize2fs rootfs.ext3.base 1248
	tune2fs -i 0 -c 0 rootfs.ext3.base

rootfs.ext4.base:
	dd if=/dev/zero of=rootfs.ext4.base bs=10M count=1
	mkfs.ext3 rootfs.ext4.base
	resize2fs rootfs.ext4.base 1539
	tune2fs -i 0 -c 0 rootfs.ext4.base

menu.json: gen.menu.json.js
	./gen.menu.json.js > menu.json

kual-linuxdeploy-armhf.zip: chroot.shell.sh config.xml install.alpine.sh lib.sh LICENSE remove.sh resize.sh rootfs.ext3.base rootfs.ext4.base umount.sh menu.json
	rm -f $@
	$(MAKE) -C ./e2fsprogs/
	7z a $@  $^ ./e2fsprogs/out/sbin/resize2fs
