#!/bin/bash
set -euo pipefail

STARTDIR=$PWD

# Get and unpack the ARM compiler tools for x64
wget -q -c https://developer.arm.com/-/media/Files/downloads/gnu-a/${GCC_VERSION}/binrel/gcc-arm-${GCC_VERSION}-x86_64-arm-none-linux-gnueabihf.tar.xz
sudo tar xf gcc-arm-${GCC_VERSION}-x86_64-arm-none-linux-gnueabihf.tar.xz -C /opt
rm gcc-arm-${GCC_VERSION}-x86_64-arm-none-linux-gnueabihf.tar.xz

# Setup the PATH to reference the newly unpacked tools.
# IMPORTANT: This export is required for configure to pickup the ARM tools
# IMPORTANT: so the path must be exported like this.
export PATH=/opt/gcc-arm-${GCC_VERSION}-x86_64-arm-none-linux-gnueabihf/bin:$PATH

# Update symbolic links to reference the ARM libraries needed for the build
sudo ln -s /opt/gcc-arm-${GCC_VERSION}-x86_64-arm-none-linux-gnueabihf/arm-none-linux-gnueabihf/libc/lib/ld-linux-armhf.so.3 /lib/ld-linux-armhf.so.3
sudo ln -s /opt/gcc-arm-${GCC_VERSION}-x86_64-arm-none-linux-gnueabihf/arm-none-linux-gnueabihf/libc/lib/libc.so.6 /lib/libc.so.6
sudo ln -s /opt/gcc-arm-${GCC_VERSION}-x86_64-arm-none-linux-gnueabihf/arm-none-linux-gnueabihf/libc/lib/libpthread.so.0 /lib/libpthread.so.0

wget https://github.com/fukuchi/libqrencode/archive/refs/tags/v${QRENCODE_VERSION}.tar.gz

tar xf v${QRENCODE_VERSION}.tar.gz

cd libqrencode-${QRENCODE_VERSION}
./autogen.sh
CFLAGS="-static -static-libgcc" ./configure \
  --host=arm-none-linux-gnueabihf \
  --without-png \
  --enable-static
make

[ -d ${STARTDIR}/Scripts/.config/speedtest ] || mkdir -p ${STARTDIR}/Scripts/.config/speedtest
cp -v qrencode ${STARTDIR}/Scripts/.config/speedtest

cd ${STARTDIR}
rm -rf libqrencode-${QRENCODE_VERSION} v${QRENCODE_VERSION}.tar.gz
