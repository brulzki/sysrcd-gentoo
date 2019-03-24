#!/bin/bash
set -e

# check for missing packages
if [[ ! -f /usr/bin/catalyst || ! -f /usr/bin/genkernel ||
      ! -d /usr/lib/grub/x86_64-efi || ! -f /bin/cpio ||
      ! -f /usr/bin/pixz || ! -f /usr/bin/xorriso ]]; then
    cat <<-EOF
	ERROR: Missing required packages to build sysrescd iso
	# emerge catalyst genkernel grub cpio pixz libisoburn
	EOF
    exit 1
fi

# /worksrc is the sysrcd build area
if [[ ! -d /worksrc/sysresccd-src ]]; then
    mkdir -p /worksrc
    git clone . /worksrc/sysresccd-src
fi

if [[ ! -e /worksrc/catalyst ]]; then
    ln -s /var/tmp/catalyst /worksrc/catalyst
fi

mkdir -p /worksrc/isofiles
mkdir -p /worksrc/sysresccd-bin/kernels-x86

# TODO: this need to be populated
mkdir -p /worksrc/sysresccd-bin/overlay-initramfs
mkdir -p /worksrc/sysresccd-bin/overlay-iso-x86

if [[ ! -d /worksrc/sysresccd-bin/overlay-iso-x86/isolinux ]]; then
    mkdir -p /worksrc/sysresccd-bin/overlay-iso-x86/isolinux
    cp -p /usr/share/syslinux/isolinux.bin \
       /worksrc/sysresccd-bin/overlay-iso-x86/isolinux
    cp -p /usr/share/syslinux/{ifcpu64,kbdmap,menu,reboot,vesamenu}.c32 \
       /worksrc/sysresccd-bin/overlay-iso-x86/isolinux
    cp -p /usr/share/syslinux/{ldlinux,libcom32,libutil}.c32 \
       /worksrc/sysresccd-bin/overlay-iso-x86/isolinux
fi

mkdir -p /worksrc/sysresccd-bin/overlay-squashfs-x86

# snapshot the portage tree
if [[ ! -f /var/tmp/catalyst/snapshots/portage-20181110.tar.bz2 ]]; then
    catalyst -s 20181110
fi

# fetch a seed stage
if [[ ! -f /var/tmp/catalyst/builds/default/stage1-i686-baseos.tar.bz2 ]]; then
    mkdir -p /var/tmp/catalyst/builds/default/
    wget -O /var/tmp/catalyst/builds/default/stage1-i686-baseos.tar.bz2 \
         https://downloads.sourceforge.net/project/systemrescuecd/sysresccd-sdk/stage1-i686-baseos-5.3.1.tar.bz2
fi

#catalyst -f mainfiles/sysresccd-base-stage1-i686.spec
catalyst -f mainfiles/sysresccd-base-stage2-i686.spec
catalyst -f mainfiles/sysresccd-base-stage3-i686.spec
catalyst -f mainfiles/sysresccd-base-stage4-i686.spec

catalyst -f mainfiles/sysresccd-live-stage1-full-i686.spec
catalyst -f mainfiles/sysresccd-live-stage2-full.spec

buildscripts/rebuild-kernel.sh rescue32
buildscripts/rebuild-kernel.sh rescue64

buildscripts/recreate-iso.sh x86
