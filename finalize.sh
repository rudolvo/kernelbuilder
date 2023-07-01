#!/bin/bash
if grep -xq "Installing UAPI kernel headers:" build.log
then
    echo Adding Image to AnyKernel flashable zip...
    git clone https://github.com/karthik558/AnyKernel3
    cp ./out/android11-5.4/dist/Image ./AnyKernel3
    cd AnyKernel3
    zip -r9 "update.zip" * -x .git README.md anykernel-real.sh .gitignore zipsigner* *.zip
else
    echo Build failed. Exiting...
    exit 2
fi