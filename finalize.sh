#!/bin/bash
if grep -q "Installing UAPI kernel headers:" build.log
then
    echo Workflow will take care the zip file.
else
    echo Build ended prematurely. Exiting...
    exit 2
fi