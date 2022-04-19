#!/bin/bash

branch="halium-7.1"
init_env() {
        git config --global user.name "liuxinsong"
        git config --global user.email "liuxinsong@uniontech.com"
        source halium.env
        export FLASHABLE_DIR=ubports-`date +%Y%m%d-%H%M%S`-devel-$DEVICE
        echo $FLASHABLE_DIR > ~/.current_version
        echo "::set-env name=VENDOR::$(echo $VENDOR)"
        echo "::set-env name=DEVICE::$(echo $DEVICE)"
        echo "::set-env name=ANDROID_ROOT::$(echo $ANDROID_ROOT)"
        echo "::set-env name=FLASHABLE_DIR::$(echo $FLASHABLE_DIR)"
}
init_python(){
	if [[ "$branch" =~ "7" ]];then
		ln -sf /usr/bin/python2 /usr/bin/python
	else
		ln -sf /usr/bin/python3 /usr/bin/python
	fi

}
download_source() {
        source halium.env
        mkdir -p $ANDROID_ROOT
        pushd $ANDROID_ROOT
        repo init -u https://github.com/Halium/android -b halium-7.1 --depth=1
        repo sync -j8 -c --no-clone-bundle --no-tags
        popd
}

clone_device_spec_source() {
        source halium.env
        git clone https://github.com/ubports-on-vince/device_xiaomi_vince.git $ANDROID_ROOT/device/xiaomi/vince --depth=1
        git clone https://github.com/ubports-on-vince/vendor_xiaomi_vince.git $ANDROID_ROOT/vendor/xiaomi/vince --depth=1
        rm -rf $ANDROID_ROOT/halium/hybris-boot
        git clone https://github.com/Sailfish-On-Vince/hybris-boot.git $ANDROID_ROOT/halium/hybris-boot
        git clone https://github.com/ubports-on-vince/Xiaomi_Kernel_OpenSource.git -b tiffany-n-oss $ANDROID_ROOT/kernel/xiaomi/msm8953 --depth=1
        git clone https://android.googlesource.com/platform/external/curl.git -b android-7.1.2_r37 $ANDROID_ROOT/external/libcurl --depth=1
}

build_hal() {
        chmod +x build-hal.sh
        bash -x build-hal.sh
}

build_package() {
        chmod +x package.sh
        bash -x package.sh
}

main() {
    init_env
    init_python
    download_source
    clone_device_spec_source
    build_hal
    build_package
}
main
