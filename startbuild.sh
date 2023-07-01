#!/bin/bash
BUILD_CONFIG=common/build.config.veux build/build.sh 2>&1 | tee build.log
