#!/bin/bash
echo "Fetching kernel..."
git clone https://github.com/PixelExperience-Devices/kernel_xiaomi_sm6375
echo "Decompressing source code..."
mv kernel_xiaomi_sm6375 kernel && cd kernel
echo "Preparing build tools"
sudo apt update > /dev/null 2>&1
sudo apt install libssl-dev clang ccache gcc-aarch64-linux-gnu bc -y
mkdir -p out
echo "Starting make..."
make clean
make mrproper
make O=out ARCH=arm64 gki_defconfig
ccache -M 50G
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
		      CC="/usr/bin/ccache clang" \
		      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-androideabi-
echo "Finishing..."
zip -r root.zip arch/arm64 > /dev/null 2>&1
zip -r out.zip out/arch/arm64 > /dev/null 2>&1				  
