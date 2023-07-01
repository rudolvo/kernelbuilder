#!/bin/bash
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