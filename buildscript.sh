#!/bin/bash
curl https://android.googlesource.com/kernel/common/+archive/34b5f809f17e66d5011086a3d90802989e667f75.tar.gz -o compr.tar.gz
mkdir kernel && cd kernel
tar -xzvf ../compr.tar.gz
sudo apt update
sudo apt install libssl-dev clang llvm gcc-aarch64-linux-gnu bc -y
mkdir -p out
make clean
make mrproper
make O=out ARCH=arm64 gki_defconfig
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-androideabi-
					  
zip -r out out
