#/bin/bash
getsource () {
    git clone --depth=1 https://github.com/MiCode/Xiaomi_Kernel_OpenSource -b veux-r-oss common
}
gettools () {
    echo ==================================
    echo Downloading back-end build scripts
    git clone --depth=1 https://android.googlesource.com/kernel/build -b master-kernel-build-2021 build
    echo ============================
    echo Downloading build essentials
    git clone --depth=1 https://android.googlesource.com/kernel/prebuilts/build-tools -b master-kernel-build-2021 prebuilts/kernel-build-tools
    git clone --depth=1 https://android.googlesource.com/platform/prebuilts/build-tools -b master-kernel-build-2021 prebuilts/build-tools
    echo =================
    echo Downloading Clang toolchain
    #source: https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/refs/heads/android11-qpr2-release/clang-r383902b1/
    curl -s -o clang-r383902b1/clang.zip --create-dirs https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android11-qpr2-release/clang-r383902b1.tar.gz
    cd clang-r383902b1
    tar -xzf clang.zip
    cd ..
    echo ====================
    echo Extracting assembler
    #source: https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9
    #        https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9
    mkdir gcc && cd gcc
    unzip -q ../lineageos-tc.zip
    cd ..
    echo ==================================
    echo Installing additional dependencies
    sudo apt update > /dev/null 2>&1
    sudo apt install -y rsync
}
startbuild () {
    echo Copying configs
    cp build.config.veux common/
    cp qgki_defconfig common/arch/arm64/configs/
    echo Available threads: $(nproc)
    echo .
    if grep -q "V=1" common/build.config.veux
    then
        #Prevent console flooding in verbose mode
        BUILD_CONFIG=common/build.config.veux build/build.sh > build.log 2>&1
    else
        BUILD_CONFIG=common/build.config.veux build/build.sh 2>&1 | tee build.log
    fi
}
finalize () {
    if grep -q "Files copied to" build.log
    then
        mv out/android11-5.4/dist/Image AnyKernel3
        mv build.log AnyKernel3
        echo Workflow will take care the zip file.
    else
        echo Build ended prematurely. Exiting...
        exit 2
    fi
}
if [ $1='getsource' ]; then
    getsource
    elif [ $1='gettools' ]; then
        gettools
        elif [ $1='startbuild' ]; then
            startbuild
            elif [ $1='finalize' ]; then
                finalize
else
    echo Build will start in sequence.
    
fi


