#!/bin/bash
source halium.env
cd $ANDROID_ROOT

# replace something
sed -i 's/external\/selinux/external\/selinux external\/libcurl/g' build/core/main.mk

# droidmedia
echo 'DROIDMEDIA_32 := true' >> external/droidmedia/env.mk
echo 'FORCE_HAL:=1' >> external/droidmedia/env.mk
echo 'MINIMEDIA_AUDIOPOLICYSERVICE_ENABLE := 1' >> external/droidmedia/env.mk
echo 'AUDIOPOLICYSERVICE_ENABLE := 1' >> external/droidmedia/env.mk

#manually clone gpg
git clone https://github.com/fredldotme/android_external_gpg.git --depth=1 external/gpg

# for more space
rm -rf .repo

source build/envsetup.sh
virtualenv --python 2.7 ~/python27
source ~/python27/bin/activate
export USE_CCACHE=1
breakfast $DEVICE
make -j$(nproc) hybris-boot halium-boot systemimage

echo "md5sum halium-boot.img and system.img"
md5sum $ANDROID_ROOT/out/target/product/${DEVICE}/halium-boot.img
md5sum $ANDROID_ROOT/out/target/product/${DEVICE}/system.img
