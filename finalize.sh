#!/bin/bash
if grep -q "Files copied to" build.log
then
    echo Workflow will take care the zip file.
else
    echo Build ended prematurely. Exiting...
    exit 2
fi