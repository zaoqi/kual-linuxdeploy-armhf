FROM multiarch/debian-debootstrap:armel-jessie
# jessie: in order to support linux 2.6
#RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
#RUN sed -i 's|security.debian.org|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list
RUN apt update
RUN apt install -y gcc dietlibc-dev aria2 make
RUN mkdir /src
ARG e2fsprogs_version=1.45.4
RUN cd /src && aria2c -o e2fsprogs-${e2fsprogs_version}.tar.gz -k 1048576 -s 32768 -j 32768 -x 16 -k 1M https://kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v${e2fsprogs_version}/e2fsprogs-${e2fsprogs_version}.tar.gz
RUN cd /src && tar -xzvf e2fsprogs-${e2fsprogs_version}.tar.gz
RUN cd /src/e2fsprogs-${e2fsprogs_version} && ./configure --prefix=/src --disable-threads --disable-tls --disable-nls --with-diet-libc --disable-imager --disable-debugfs --disable-defrag --disable-fuse2fs --disable-fsck --disable-e2initrd-helper
RUN cd /src/e2fsprogs-${e2fsprogs_version} && make -j4
RUN cd /src/e2fsprogs-${e2fsprogs_version} && make install
