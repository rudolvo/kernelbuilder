#/bin/bash
if [ ! -d "common" ]; then
    chmod +x getsource.sh
    bash getsource.sh
fi
if [ ! -d "build" ]; then
    chmod +x gettools.sh
    bash gettools.sh
fi
if [ ! -f common/build.config.veux ]; then
    chmod +x addconfig.sh
    bash addconfig.sh
fi
chmod +x startbuild.sh
bash startbuild.sh
