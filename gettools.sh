#!/bin/bash
echo =====Downloading build.sh======
git clone --depth=1 https://android.googlesource.com/kernel/build -b master-kernel-build-2021 build
echo =====Downloading build essentials=====
git clone --depth=1 https://android.googlesource.com/kernel/prebuilts/build-tools -b master-kernel-build-2021 prebuilts/kernel-build-tools
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/build-tools -b master-kernel-build-2021 prebuilts/build-tools
echo =====Downloading Clang=====
#source: https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/refs/heads/android11-qpr2-release/clang-r383902b1/
curl -o clang-r383902b1/clang.zip --create-dirs https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android11-qpr2-release/clang-r383902b1.tar.gz
cd clang-r383902b1
tar -xzf clang.zip
cd ..
echo =====Downloading assembler=====
#source: https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9
#        https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9
mkdir gcc && cd gcc
unzip -q ../lineageos-tc.zip
cd ..
echo =====Installing additional dependencies=====
sudo apt update > /dev/null 2>&1
sudo apt install -y rsync