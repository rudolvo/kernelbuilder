#!/bin/bash
git config --global user.email "nhat.dogpro@outlook.com"
git config --global user.name "katyusha256"
mkdir kernel && cd kernel

sudo apt update
sudo apt install repo git

repo init -u https://android.googlesource.com/kernel/manifest
mv ../manifest.xml .repo/manifests
repo init -m manifest.xml
#repo sync

cd ..
#git add ./kernel/*
git commit -m "All files" #> /dev/null 2>&1
