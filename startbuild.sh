#!/bin/bash
echo Available threads: $(nproc)
echo.
BUILD_CONFIG=common/build.config.veux build/build.sh 2>&1 | tee build.log
