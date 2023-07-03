#/bin/bash

#Uncomment for a KernelSU build
KSU=1

case $HOSTNAME in
  (fv-az*)  ISACTIONS=1 ;;
  (*)  ISACTIONS=0 ;;
esac

getsource () {
    if [ ! -d "common" ]; then
    echo Downloading kernel source...
    git clone --depth=1 https://github.com/MiCode/Xiaomi_Kernel_OpenSource -b veux-r-oss common
    fi
}
gettools () {
    if [ ! -d "build" ]; then
    echo ==================================
    echo Downloading back-end build scripts
    git clone --depth=1 https://android.googlesource.com/kernel/build -b master-kernel-build-2021 build
    fi
    if [ ! -d "prebuilts" ]; then
    echo ============================
    echo Downloading build essentials
    git clone --depth=1 https://android.googlesource.com/kernel/prebuilts/build-tools -b master-kernel-build-2021 prebuilts/kernel-build-tools
    git clone --depth=1 https://android.googlesource.com/platform/prebuilts/build-tools -b master-kernel-build-2021 prebuilts/build-tools
    fi
    if [ ! -d "clang" ]; then
    echo ===========================
    echo Downloading Clang toolchain
    #source: https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/refs/heads/android11-qpr2-release/clang-r383902b1/
    if [ $ISACTIONS = 1 ]; then
    curl -s -o clang/clang.zip --create-dirs https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android11-qpr2-release/clang-r383902b1.tar.gz
    else curl -o clang/clang.zip --create-dirs https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android11-qpr2-release/clang-r383902b1.tar.gz
    fi
    cd clang
    tar -xzf clang.zip
    cd ..
    fi
    if [ ! -d "gcc" ]; then
    echo ====================
    echo Extracting assembler
    #source: https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9
    #        https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9
    mkdir gcc && cd gcc
    unzip -q ../lineageos-tc.zip
    cd ..
    fi
    echo ==================================
    #echo Installing additional dependencies
    #sudo apt update > /dev/null 2>&1
    #sudo apt install -y rsync
}
startbuild () {
    echo Copying configs
    cp build.config.veux common/
    cp qgki_defconfig common/arch/arm64/configs/
    cp common/arch/arm64/configs/vendor/veux_QGKI.config common/arch/arm64/configs/perf_defconfig
    if [[ "$1" == *"-ksu"* ]] || [[ "$2" == *"-ksu"* ]] || [ $KSU = 1 ]; then
        echo Integrating KernelSU
        curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
    fi
    echo Build started on $HOSTNAME with $(nproc) threads
    echo Target:
    echo Android $(grep -m 1 "VERSION" common/Makefile | sed 's/.*= *//' | tr -d ' ').$(grep -m 1 "PATCHLEVEL" common/Makefile | sed 's/.*= *//' | tr -d ' ').$(grep -m 1 "SUBLEVEL" common/Makefile | sed 's/.*= *//' | tr -d ' ') '(commit' $(cd common && git rev-parse HEAD | cut -c 1-8)')'
    echo Calling back-end script...
    if [ $ISACTIONS = 1 ]; then
        echo "INFO: GitHub Actions host detected, build log won't piped/redirected"
        #since Action's console is already a piped output, and Clang won't handle two pipes properly
        echo "INFO: To retrieve logs, click the gear button next to "Search logs" then "Download log archive""
        BUILD_CONFIG=common/build.config.veux build/build.sh
    elif grep -q "V=1" common/build.config.veux; then
        #Prevent console flooding in verbose mode
        BUILD_CONFIG=common/build.config.veux build/build.sh > build.log 2> >(tee -a build.log >&2)
    else
        BUILD_CONFIG=common/build.config.veux build/build.sh 2>&1 | tee build.log
    fi
}
finalize () {
    if [ -e "out/android11-5.4/dist/Image" ]; then
        cp out/android11-5.4/dist/Image AnyKernel3
        if [ $ISACTIONS = 1 ]; then echo Workflow will pack up zip file as artifact.
        else
            echo Packing to updater zip...
            cd AnyKernel3
            zip -r5 AnyKernel3_veux_$(date +%Y%m%d).zip .
            mv *.zip .. && cd ..
        fi
    else
        echo Build ended prematurely. Exiting...
        exit 2
    fi
}
if [ -n "$1" ]; then
    case "$1" in
        "getsource") getsource ;;
        "gettools") gettools ;;
        "startbuild") startbuild ;;
        "finalize") finalize ;;
        "debug-cleanup")
            rm -rf common/ build/ prebuilts/ gcc/ out/ clang/ KernelSU/
            rm AnyKernel3/Image
            rm build.log
            ;;
        *)
            echo "Error: Invalid argument '$1'"
            exit 1
            ;;
    esac
else
    getsource
    gettools
    startbuild
    finalize
fi
