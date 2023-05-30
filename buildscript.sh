#!/bin/bash
git config --global user.email "nhat.dogpro@outlook.com"
git config --global user.name "katyusha256"
mkdir kernel && cd kernel

sudo apt update
sudo apt install repo git

repo init -u https://android.googlesource.com/kernel/manifest
mv ../manifest.xml .repo/manifests
repo init -m manifest.xml
repo sync
rm -rf .git
rm -rf .repo

curl https://android.googlesource.com/kernel/common/+archive/34b5f809f17e66d5011086a3d90802989e667f75.tar.gz -o common.tar.gz
mkdir common && cd common
tar -xzf ../common.tar.gz
rm ../common.tar.gz
cd ..
cd ..

zip -r source.zip kernel
rm -rf kernel
git lfs track source.zip
git add .
git commit -m "All files" #> /dev/null 2>&1
