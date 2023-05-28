#!/bin/bash
mkdir kernel && cd kernel
tar -xzf ../source.tar.gz
sudo apt update > /dev/null 2>&1
sudo apt install libssl-dev clang llvm gcc-aarch64-linux-gnu bc -y
mkdir -p out
make clean
make mrproper
make O=out ARCH=arm64 gki_defconfig
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
		      LLVM=1 \
		      LLVM_IAS=0 \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-androideabi-
zip -r root.zip arch/arm64 > /dev/null 2>&1
zip -r out.zip out/arch/arm64 > /dev/null 2>&1				  
