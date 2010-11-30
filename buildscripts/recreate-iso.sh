#!/bin/sh

VERSION="1.6.4"
EXTRAVER=""
VOLNAME="sysrcd-1.6.4"
ISODIR=/worksrc/isofiles
TEMPDIR=/worksrc/catalyst/isotemp
REPOSRC=/worksrc/sysresccd-src-1.6
REPOBIN=/worksrc/sysresccd-bin-1.6

# ==================================================================
# ==================================================================

usage()
{
	echo "Usage: $0 <arch> <options>"
	echo "  arch = x86 | amd64 | sparc"
}

if [ "$1" = "x86" ] || [ "$1" = "amd64" ] || [ "$1" = "sparc" ]
then
	CURARCH="$1"
else
	usage
	exit 1
fi

# ========= copy files from the temp iso image ================================
CURFILE="${ISODIR}/systemrescuecd-${CURARCH}-current.iso"
MYDATE=$(date +%Y%m%d-%Hh%M)
DESTDIR=/home/sysresccdiso
mkdir -p ${DESTDIR}

if [ ! -f "${CURFILE}"  ]
then
	echo "Cannot find \"${CURFILE}\". Failed"
	exit 1
fi

umount /mnt/cdrom 2>/dev/null
if ! mount -o loop,ro ${CURFILE} /mnt/cdrom
then
	echo "Cannot mount ${CURFILE}"
	exit 1
fi

if [ ! -f /mnt/cdrom/image.squashfs ]
then
	echo "Cannot find a valid file in the ISO"
	exit 1
fi

[ -d ${TEMPDIR} ] && rm -rf ${TEMPDIR} 
mkdir -p ${TEMPDIR}
cp /mnt/cdrom/isolinux/rescuecd* ${REPOBIN}/kernels-x86/
cp /mnt/cdrom/image.squashfs ${TEMPDIR}/sysrcd.dat
( cd ${TEMPDIR} ; md5sum sysrcd.dat > sysrcd.md5 ; chmod 644 sysrcd.* ) 
umount /mnt/cdrom

# ========= copy files from overlays ===========================================
rsync -ax ${REPOBIN}/overlay-iso-x86/ "${TEMPDIR}/"
rsync -ax ${REPOSRC}/overlay-iso-x86/ "${TEMPDIR}/"
rsync -ax ${REPOBIN}/kernels-x86/ ${TEMPDIR}/isolinux/
cp ${REPOSRC}/overlay-squashfs-x86/root/version ${TEMPDIR}

# ========= integrate the version number in f1boot.msg =========================
TXTVERSION=$(cat ${REPOSRC}/overlay-squashfs-x86/root/version)
for fixfile in isolinux.cfg f1boot.msg
do
	sed -i -e "s/SRCDVER/${TXTVERSION}${EXTRAVER}/" ${TEMPDIR}/isolinux/${fixfile}
done

# ========= merge (rescuecd.igz+rescue64.igz+altker32.igz) --> rescuecd.igz ====
curdir="${TEMPDIR}/isolinux"
newramfs="${curdir}/initram-root"
newinitrfs="${curdir}/initram.igz"

# prepare root of new initramfs
[ -d ${newramfs} ] && rm -rf ${newramfs}
mkdir -p ${newramfs}
cp -a ${REPOBIN}/overlay-initramfs/* ${newramfs}/

# copy custom busybox binary to the new initramfs
( cd ${newramfs}/bin/ ; ln busybox sh )

# update the init boot script in the initramfs
cp ${REPOSRC}/mainfiles/init ${newramfs}/init

# build new initramfs
echo 'building the new initramfs...'
( cd ${newramfs} && find . | cpio -H newc -o | lzma -5 > ${newinitrfs} )

# remove old igz-images and tmp-dirs
[ -d ${newramfs} ] && rm -rf ${newramfs} 

# ========= copy the new files to the pxe environment =========================
if [ -d /tftpboot ]
then
	cp ${TEMPDIR}/sysrcd.dat /tftpboot/
	cp ${TEMPDIR}/sysrcd.md5 /tftpboot/
	cp ${TEMPDIR}/isolinux/* /tftpboot/
fi

# ========= prepare the ISO image =============================================
ISOFILE="${DESTDIR}/systemrescuecd-${CURARCH}-${VERSION}-${MYDATE}.iso"

if [ "${CURARCH}" = "x86" ] || [ "${CURARCH}" = "amd64" ]
then
	mkisofs -J -l -V ${VOLNAME} -input-charset utf-8 -o ${ISOFILE} -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table ${TEMPDIR}
	#/usr/bin/isohybrid ${ISOFILE}
fi

if [ "${CURARCH}" = "sparc" ]
then
	mkisofs -G /boot/isofs.b -J -V ${VOLNAME} -B ... -r -o ${ISOFILE} ${TEMPDIR}
fi

# ========= copy list of packages ===============================================
cp /var/tmp/catalyst/tmp/default/livecd-stage2-i386-1.6-std/root/sysresccd-eix.txt ${REPOSRC}/pkglist/sysresccd-x86-packages-eix-${TXTVERSION}.txt
cp /var/tmp/catalyst/tmp/default/livecd-stage2-i386-1.6-std/root/sysresccd-pkg.txt ${REPOSRC}/pkglist/sysresccd-x86-packages-std-${TXTVERSION}.txt

# ========= prepare the backup ==================================================
tar cfJp "${DESTDIR}/systemrescuecd-${CURARCH}-${VERSION}-${MYDATE}.tar.xz" ${REPOSRC} ${REPOBIN} /worksrc/sysresccd-win* --exclude='.git'

# ========= force recompilation of sys-apps/sysresccd-scripts ===================
rm -f /var/tmp/catalyst/packages/default/livecd-stage2-*/sys-apps/sysresccd-*.tbz2
rm -f /var/tmp/catalyst/packages/default/livecd-stage2-*/sys-kernel/genkernel-*.tbz2

