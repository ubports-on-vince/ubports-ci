#!/bin/bash

# Script to package system.img to flashable zip

LOCAL_WORKDIR=/home/runner/work/

source halium.env

function checkoutHaliuminstall(){
    cd $LOCAL_WORKDIR
    git clone https://github.com/JBBgameich/halium-install.git
    # comment adb 
    sed -i 's/adb/#adb/' halium-install/functions/core.sh
    # comment clean 
    sed -i 's/trap clean_exit/#trap clean_exit/' halium-install/halium-install
    chmod +x halium-install/halium-install
}

function downloadRootfsTar(){
    cd $LOCAL_WORKDIR
    curl -LO https://ci.ubports.com/job/xenial-mainline-edge-rootfs-arm64/lastSuccessfulBuild/artifact/out/ubuntu-touch-xenial-edge-arm64-rootfs.tar.gz
}

function convertImgtoRootfsImg(){
    cd $LOCAL_WORKDIR
    halium_install=$1
    rootfs_tar=$2
    systemimg=$3
    $halium_install -p ut -u 1234 -r 1234 $rootfs_tar $systemimg
    ls .halium-install-imgs.*
}


function makeFlashableZip(){
    cd $LOCAL_WORKDIR
    zipfolder=$FLASHABLE_DIR
    mv .halium-install-imgs.*/*.img $zipfolder/
    cp -R ubports-ci/META-INF $zipfolder/
    chmod +x $zipfolder/META-INF/com/google/android/updat*
    cp $ANDROID_ROOT/out/target/product/$DEVICE/halium-boot.img $zipfolder/
    cd $zipfolder
    gzip rootfs.img
    gzip system.img
    zip -r ../$zipfolder.zip `ls .`
}


function main(){
    checkoutHaliuminstall
    downloadRootfsTar
    convertImgtoRootfsImg halium-install/halium-install ubuntu-touch-xenial-edge-arm64-rootfs.tar.gz \
    $ANDROID_ROOT/out/target/product/$DEVICE/system.img
    makeFlashableZip
    echo "All is done ;)"
}

main