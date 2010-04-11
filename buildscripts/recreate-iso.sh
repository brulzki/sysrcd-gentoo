#!/bin/sh

VERSION="1.5.2"
EXTRAVER=""
VOLNAME="sysrcd-1.5.2"
ISODIR=/worksrc/isofiles
TEMPDIR=/worksrc/catalyst/isotemp
REPOSRC=/worksrc/sysresccd-src
REPOBIN=/worksrc/sysresccd-bin

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
rsync -ax ${REPOSRC}/overlay-iso-x86/isolinux/ "${TEMPDIR}/isolinux/"
rsync -ax ${REPOBIN}/kernels-x86/ ${TEMPDIR}/isolinux/ --exclude='*.igz'
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
modulesdir="${newramfs}/lib/modules"

# prepare root of new initramfs
[ -d ${newramfs} ] && rm -rf ${newramfs}
mkdir -p ${newramfs}
cp -a ${REPOBIN}/overlay-initramfs/* ${newramfs}/
mkdir -p ${modulesdir}

# extract the old ramdisks
#for ker in rescuecd rescue64 altker32 altker64
#do
#        oldimg="${REPOBIN}/kernels-x86/${ker}.igz"
#        newdir="${curdir}/${ker}-tmp"
#        echo "extracting ${oldimg}..."
#        mkdir -p "${newdir}"
#        ( cd "${newdir}" && cat ${oldimg} | gzip -d | cpio -id 2>/dev/null )
#done

# copy {rescue64,altker32,altker64}/lib/modules to the new initramfs
#for ker in rescuecd rescue64 altker32 altker64
#do
#        cp -a ${curdir}/${ker}-tmp/lib/modules/* ${modulesdir}/
#done

# copy custom busybox binary to the new initramfs
#cp ${curdir}/rescuecd-tmp/bin/busybox ${newramfs}/bin/
( cd ${newramfs}/bin/ ; ln busybox sh )

# update the init boot script in the initramfs
cp ${REPOSRC}/mainfiles/linuxrc* ${newramfs}/
cp ${REPOSRC}/mainfiles/linuxrc ${newramfs}/init

# strip and compress kernel modules which are in the sysrcd.dat to save space
find ${modulesdir} -name "*.ko" -exec strip --strip-unneeded '{}' \;
find ${modulesdir} -name "*.ko" -exec gzip '{}' \;

# build new initramfs
echo 'building the new initramfs...'
( cd ${newramfs} && find . | cpio -H newc -o | lzma -5 > ${newinitrfs} )

# remove old igz-images and tmp-dirs
[ -d ${newramfs} ] && rm -rf ${newramfs} 
for ker in rescuecd rescue64 altker32 altker64
do
        #[ -f "${curdir}/${ker}.igz" ] && rm -f "${curdir}/${ker}.igz"
        [ -d "${curdir}/${ker}-tmp" ] && rm -rf "${curdir}/${ker}-tmp"
done

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
fi

if [ "${CURARCH}" = "sparc" ]
then
	mkisofs -G /boot/isofs.b -J -V ${VOLNAME} -B ... -r -o ${ISOFILE} ${TEMPDIR}
fi

# ========= prepare the backup ==================================================
tar cfjp "${DESTDIR}/systemrescuecd-${CURARCH}-${VERSION}-${MYDATE}.tar.bz2" /worksrc/sysresccd-src /worksrc/sysresccd-bin --exclude='.git'

