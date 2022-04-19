FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y bc bison build-essential bzr ccache curl wget \
       device-tree-compiler dosfstools flex gcc-multilib \
       git git-core g++-multilib gnupg gperf htop iftop \
       imagemagick iotop lib32ncurses5-dev lib32z-dev \
       libc6-dev libc6-dev-i386 libgl1-mesa-dev python3-pip \
       libgl1-mesa-glx:i386 liblz4-tool libncurses5 \
       libncurses5-dev:i386 libreadline6-dev:i386 libx11-dev \
       libx11-dev:i386 libxml2-utils lunzip lzop mingw-w64-i686-dev \
       mtools openjdk-8-jdk parted pigz python python-markdown \
       python-pip repo rsync schedtool sysstat tofrodos u-boot-tools \
       cpio android-tools-adb qemu-user-static qemu-system-arm \
       e2fsprogs simg2img virtualenv gzip squashfs-tools yasm libtinfo5 libxml2 \
       udev unzip vim-common x11proto-core-dev xsltproc zip zlib1g-dev zlib1g-dev:i386 \
       pngcrush sudo
RUN pip3 install pycrypto requests && \
    curl https://mirrors.tuna.tsinghua.edu.cn/git/git-repo -o /usr/local/bin/repo && \
    chmod a+x /usr/local/bin/repo && \
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
ENV CLASSPATH=.:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar
ENV REPO_URL='https://mirrors.tuna.tsinghua.edu.cn/git/git-repo/'
COPY entrypoint.sh /entrypoint.sh
WORKDIR /home/runner
ENTRYPOINT [ "/entrypoint.sh" ]
