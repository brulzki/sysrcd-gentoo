#!/bin/bash

# This is an example fsscript for use with the livecd-stage2 target (key
# livecd/fsscript).  This file is copied into the rootfs of the CD after the
# kernel(s) and any external modules have been compiled and is then executed
# within the context of the chroot.

# define hostname
rm -f /etc/conf.d/hostname
echo "HOSTNAME=sysresccd" > /etc/conf.d/hostname
sed -i -e 's/livecd/sysresccd/g' /etc/hosts

# clean the resolv.conf file ("dig . ns" to get list of root DNS)
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# change the default shell
chsh -s /bin/zsh root

# Remove python precompiled files
find /usr/lib -name "*.py?" -exec rm -f {} \; >/dev/null 2>&1

# Remove old files
find /etc -name "._cfg*" -exec rm -f {} \; >/dev/null 2>&1

# remove warning from clock service
[ -f /etc/conf.d/clock ] && sed -i -e 's:#TIMEZONE="Factory":TIMEZONE="Europe/London":g' /etc/conf.d/clock

# remove warning from freshclam when clamd not running
sed -i -e 's:NotifyClamd:#NotifyClamd:' /etc/freshclam.conf

# disable DHCP by default in autoconfig
sed -i -e 's/ewarn "Skipping DHCP broadcast detection as requested on boot commandline ..."//' /etc/init.d/autoconfig
sed -i -e 's/DHCP="yes"/DHCP="no"/' /etc/init.d/autoconfig

# running hwsetup disturbs the speakup, so run "hwsetup -f" when speakup is used
sed -i -e 's!\[ -x /usr/sbin/hwsetup \] && hwsetup!cat /proc/cmdline | grep -qF "speakup=" \&\& speakupopt=" -f" ; \[ -x /usr/sbin/hwsetup \] \&\& hwsetup ${speakupopt}!g' /etc/init.d/autoconfig

# disable netplug
[ -f /etc/init.d/net.lo ] && sed -i -e 's/"netplugd"//' /etc/init.d/net.lo

# make ssh-keygen silent in the sshd initscript
sed -i -e 's!/usr/bin/ssh-keygen!/usr/bin/ssh-keygen -q!g' /etc/init.d/sshd

# disable ALSA sound by default in autoconfig
sed -i -e 's/GPM="yes"/GPM="no"/' /etc/init.d/autoconfig
sed -i -e 's/ALSA="yes"/ALSA="no"/' /etc/init.d/autoconfig
sed -i -e 's/NFS="yes"/NFS="no"/' /etc/init.d/autoconfig
sed -i -e 's/PCMCIA="yes"/PCMCIA="no"/' /etc/init.d/autoconfig
sed -i -e 's/Skipping ALSA detection as requested on command line .../Skipping ALSA detection .../' /etc/init.d/autoconfig

# /sbin/livecd-functions.sh expect 'cdroot' in /proc/cmdline (we removed cdroot)
sed -i -e 's!for x in ${CMDLINE}!for x in ${CMDLINE} cdroot!g' /sbin/livecd-functions.sh

# avoid warning
echo "rc_sys=''" >> /etc/rc.conf

# update clamav virus definitions
chown clamav:clamav /var/log/clamav
chown clamav:clamav /var/run/clamav
chown clamav:clamav /var/lib/clamav
chown clamav:clamav /var/lib/clamav/*
/usr/bin/freshclam

# remove warnings about files with a modification time in the future!
[ -f /etc/init.d/depscan.sh ] && sed -i -e 's!if \[\[ ${clock_screw} == 1 \]\]!if \[\[ ${clock_screw} == 2 \]\]!g' /etc/init.d/depscan.sh
[ -f /sbin/depscan.sh ] && sed -i -e 's!if \[\[ ${clock_screw} == 1 \]\]!if \[\[ ${clock_screw} == 2 \]\]!g' /sbin/depscan.sh
[ -f /etc/init.d/savecache ] && sed -i -e 's!ewarn "WARNING: clock skew detected!#ewarn "WARNING: clock skew detected!g' /etc/init.d/savecache

# don't overwrite /proc/sys/kernel/printk in /etc/init.d/autoconfig
# http://www.sysresccd.org/forums/viewtopic.php?p=5800
sed -i -r -e 's!echo "[0-9]" > /proc/sys/kernel/printk!!g' /etc/init.d/autoconfig

# fix /sbin/livecd-functions.sh that fixes inittab
# http://www.sysresccd.org/forums/viewtopic.php?t=2040&postdays=0&postorder=asc&start=15
sed -i -e 's!s0:12345:respawn:/sbin/agetty -nl /bin/bashlogin!s0:12345:respawn:/sbin/agetty -L -nl /bin/bashlogin!g' /sbin/livecd-functions.sh

# prevent the firmware extraction from displaying warnings when the clock is wrong
sed -i -e 's!tar xjf /lib/firmware.tar.bz2!tar xjfm /lib/firmware.tar.bz2!g' /etc/init.d/autoconfig

# fix a bug in the default mtools configuration file
sed -i -e 's!SAMPLE FILE!#SAMPLE FILE!g' /etc/mtools/mtools.conf

# don't use fbdev as the default xorg driver since framebuffer is disabled
sed -i -e 's![ -z "${XMODULE}" ] && XMODULE="fbdev"![ -z "${XMODULE}" ] && XMODULE="vesa"!g' /usr/sbin/mkxf86config.sh

# prevent sshd from complaining
touch /var/log/lastlog

# preserve the 'ar' and 'strings' binaries from the binutils package (and its libs)
cp -a /usr/i486-pc-linux-gnu/binutils-bin/*/ar /usr/sbin/
cp -a /usr/i486-pc-linux-gnu/binutils-bin/*/strings /usr/sbin/
cp -a /usr/lib/binutils/i486-pc-linux-gnu/*/libbfd*.so /usr/lib/

# provide a symblink to libstdc++.so.6 so that we can install all packages
ln -s /lib/lib/gcc/i486-pc-linux-gnu/*/libstdc++.so.6 /usr/lib/libstdc++.so.6

# replace the strings-static binary (provided by app-forensics/chkrootkit) to save splace
rm -f /usr/sbin/strings-static ; ln -s /usr/sbin/strings /usr/sbin/strings-static

# make space by removing the redundant insmod.static binary
rm -f /sbin/insmod.static ; ln -s /sbin/insmod /sbin/insmod.static

# remove rdev-rebuild temp files
rm -f /var/cache/revdep-rebuild/*

# create link for reiserfsck
echo "==> creating /sbin/fsck.reiserfs"
[ ! -f /sbin/fsck.reiserfs ] && ln /sbin/reiserfsck /sbin/fsck.reiserfs

# prevent the /etc/init.d/net.eth* from being run --> they break the network (done via "ethx, dns, gateway")
echo "==> removing old net.eth*"
rm -f /etc/init.d/net.eth*

# remove xfce icons for missing programs
echo "==> removing desktop files for missing programs"
rm -f /usr/share/applications/{xfce4-file-manager.desktop,xfce4-help.desktop}

# decompress oscar files
echo "==> extracting oscar"
if [ -f /usr/share/oscar/oscar.tar.gz ]
then
	tar xfzp /usr/share/oscar/oscar.tar.gz -C /usr/share/oscar
	rm -rf /usr/share/oscar/oscar.tar.gz
fi

# update fonts when exiting from xorg
sed -i -e 's!exit $retval!source /etc/conf.d/consolefont\nsetfont $CONSOLEFONT\nexit $retval!' /usr/bin/startx

# for programs that expect syslog
echo "==> creating /usr/sbin/syslog "
ln -s /usr/sbin/syslog-ng /usr/sbin/syslog

# uncompress gzip/bzip2 files (double compression with squashfs-lzma makes the ISO bigger)
echo "==> uncompressing gzipped fonts and keymaps"
for curdir in '/usr/share/consolefonts' '/usr/share/consoletrans' '/usr/share/fonts' '/usr/share/i18n/charmaps' '/usr/share/keymaps'
do
	echo "find ${curdir} -name "*.gz" -exec gzip -d {} \;"
	find ${curdir} -name "*.gz" -exec gzip -d {} \;
done
/usr/bin/mkfontdir -e /usr/share/fonts/encodings -- /usr/share/fonts/100dpi /usr/share/fonts/75dpi /usr/share/fonts/misc /usr/share/fonts/terminus /usr/share/fonts/TTF /usr/share/fonts/Type1 /usr/share/fonts/unifont

# install 32bit kernel modules
echo "==> installing 32bit kernel modules"
for modtar in /lib/modules/*.tar.bz2
do
	echo '--------------------------------------------------------------'
	kerver=$(basename $modtar | sed -e 's/.tar.bz2//')
	echo "DECOMPRESS32 (version [$kerver]): tar xfjp $modtar -C /lib/modules/"
	tar xfjp $modtar -C /lib/modules/
	rm -f $modtar
	echo '--------------------------------------------------------------'
done

# install 64bit kernel modules
echo "==> installing 64bit kernel modules"
for modtar in /lib64/modules/*.tar.bz2
do
	echo '--------------------------------------------------------------'
	kerver=$(basename $modtar | sed -e 's/.tar.bz2//')
	echo "DECOMPRESS64 (version [$kerver]): tar xfjp $modtar -C /lib64/modules/"
	tar xfjp $modtar -C /lib64/modules/
	echo "LINK64: ln -s /lib64/modules/$kerver /lib/modules/$kerver"
	ln -s /lib64/modules/$kerver /lib/modules/$kerver
	rm -f $modtar
	echo '--------------------------------------------------------------'
done

# strip kernel modules which are in the sysrcd.dat to save space
echo "==> strip kernel modules"
find /lib/modules -name "*.ko" -exec strip --strip-unneeded '{}' \;
find /lib64/modules -name "*.ko" -exec strip --strip-unneeded '{}' \;

# run depmod on all kernels
echo "==> run depmod for all kernels"
for kerdir in /lib/modules/*
do
	kerver=$(basename ${kerdir})
	echo "*) depmod -a ${kerver}"
	depmod -a ${kerver}
done

# update /etc/make.profile
echo "==> updating /etc/make.profile"
rm -rf /etc/make.profile
ln -s ../usr/portage/profiles/default/linux/x86/10.0 /etc/make.profile

# update the database for locate
echo "==> locate -u"
locate -u >/dev/null 2>&1

# create the apropos / whatis database (time consuming: only for final releases)
if ! grep -q beta /root/version
then
	echo "==> running makewhatis"
	makewhatis >/dev/null 2>&1
fi

# create the locales:
echo "==> creating main locales"
localedef -i /usr/share/i18n/locales/en_US -f UTF-8 /usr/lib/locale/en_US.utf8
localedef -i /usr/share/i18n/locales/en_US -f ISO-8859-1 /usr/lib/locale/en_US
localedef -i /usr/share/i18n/locales/de_DE -f ISO-8859-1 /usr/lib/locale/de_DE
localedef -i /usr/share/i18n/locales/fr_FR -f ISO-8859-1 /usr/lib/locale/fr_FR

# fix dmraid
ln -s /usr/lib/libdmraid.so /usr/lib/libdmraid.so.1
ln -s /usr/lib/libdmraid-events-isw.so /usr/lib/libdmraid-events-isw.so.1

# workaround for mkfs.btrfs which wants to find /boot/sysrcd.dat
touch /boot/sysrcd.dat

# ----- OpenRC specific stuff
echo "==> OpenRC adjustments"
if [ -d /usr/share/openrc ]
then
	# enable services
	/sbin/rc-update add lvm boot
	/sbin/rc-update add sshd default
	/sbin/rc-update add sysresccd default
	/sbin/rc-update add autorun default
	/sbin/rc-update add netconfig2 default
	/sbin/rc-update add tigervnc default
	/sbin/rc-update add dostartx default
	/sbin/rc-update add dbus default
	/sbin/rc-update add hald default
	/sbin/rc-update add NetworkManager default
	/sbin/rc-update add load-fonts-keymaps default

	# remove services
	/sbin/rc-update del urandom boot
	/sbin/rc-update del consolefont boot
	/sbin/rc-update del termencoding boot
	/sbin/rc-update del keymaps boot
	/sbin/rc-update del bootmisc boot
	/sbin/rc-update del root boot
	/sbin/rc-update del modules boot
	/sbin/rc-update del netmount default
	/sbin/rc-update del sysctl boot
	/sbin/rc-update del local default

	# remove services which don't make sense on a livecd
	rm -f /etc/init.d/checkfs
	rm -f /etc/init.d/checkroot
	rm -f /etc/init.d/fsck

	# remove network servics (replaced with netconfig2)
	rm -f /etc/init.d/net.*
	rm -f /etc/init.d/network
	rm -f /etc/init.d/netmount
	rm -f /etc/init.d/staticroute

	# don't unmount /livemnt/* filesystems in localmount and mount-ro
	sed -i -e "s!/libexec!/libexec|/livemnt/.*!g" /etc/init.d/localmount
	sed -i -e "s!/libexec!/libexec|/livemnt/.*!g" /etc/init.d/mount-ro
	sed -i -e "s!# Mount local filesystems!return 0 #!" /etc/init.d/localmount

	# fix dependencies
	sed -i -e 's!need root!!g' /etc/init.d/mtab
	sed -i -e 's!need fsck!!g' /etc/init.d/localmount
	sed -i -e 's!need fsck!!g' /etc/init.d/root
	sed -i -e 's!need hald!use hald!g' /etc/init.d/xdm

	# unpack firmwares
	if [ -e /lib/firmware.tar.bz2 ]
	then
		tar xfj /lib/firmware.tar.bz2 -C /lib/firmware
		rm -f /lib/firmware.tar.bz2
	fi
fi

echo "==> end of $0"
echo "----"

