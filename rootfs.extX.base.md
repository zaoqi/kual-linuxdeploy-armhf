On normal GNU/Linux:

```
dd if=/dev/zero of=rootfs.ext3.base bs=10M count=1
mkfs.ext3 rootfs.ext3.base
resize2fs rootfs.ext3.base 1248
tune2fs -i 0 -c 0 rootfs.ext3.base
```

```
dd if=/dev/zero of=rootfs.ext4.base bs=10M count=1
mkfs.ext4 rootfs.ext4.base
resize2fs rootfs.ext4.base 1539
tune2fs -i 0 -c 0 rootfs.ext4.base
```
