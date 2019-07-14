FROM multiarch/debian-debootstrap:armel-buster
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN sed -i 's|security.debian.org|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list
RUN apt update
RUN apt install -y gcc dietlibc-dev aria2
RUN cd /
RUN aria2c -k 1048576 -s 32768 -j 32768 -x 16 -k 1M http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.45.2.tar.gz
RUN tar -xzvf e2fsprogs-1.45.2.tar.gz
RUN cd /e2fsprogs-1.45.2
RUN ./configure --disable-threads --with-diet-libc --disable-imager --disable-debugfs --disable-defrag --disable-fuse2fs --disable-fsck --disable-e2initrd-helper
