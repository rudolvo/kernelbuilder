#!/bin/bash
if grep -q "Files copied to" build.log
then
    mv out/android11-5.4/dist/Image AnyKernel3
    mv build.log AnyKernel3
    echo Workflow will take care the zip file.
else
    echo Build ended prematurely. Exiting...
    exit 2
fi