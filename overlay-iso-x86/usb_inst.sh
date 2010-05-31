#!/bin/bash
# Project page: http://www.sysresccd.org/
# (C) 2010 Francois Dupoux
# This scipt is available under the GPL-2 license

## HELP AND BASIC ARGUMENT PROCESSING
#####################################

# minimal size required for sysresccd in mega-bytes
MINSIZEMB=300
PROG="${0}"

usage()
{
	cat <<EOF
${PROG}: SystemRescueCd installation script for USB-sticks
Syntax: ${PROG} <command> ...

Please, read the manual for help about how to use this script.
http://www.sysresccd.org/Online-Manual-EN

You can either run all sub-commands in the appropriate order, or you
can just use the semi-graphical menu which requires less effort:

A) Semi-graphical installation (easy to use):
   Just run "${PROG} dialog" and select the USB device

B) Sub-commands for manual installation (execute in that order):
   1) listdev               Show the list of removable media
   2) writembr <devname>    Recreate the MBR + partition table on the stick
   3) format <partname>     Format the USB-stick device (overwrites its data)
   4) copyfiles <partname>  Copy all the files from the cdrom to the USB-stick
   5) syslinux <partname>   Make the device bootable

C) Extra sub-commands:
   -h|--help	            Display these instructions

Distributed under the GNU Public License version 2 - http://www.sysresccd.org
EOF
}

cdfiles=('sysrcd.dat' 'sysrcd.md5' 'version' '???linux/initram.igz' 
	'???linux/rescuecd' '???linux/rescue64' '???linux/f1boot.msg'
	'???linux/???linux.bin' '???linux/???linux.cfg')

## MISC FUNCTIONS: Many utilities functions
###########################################

# show the error message ($1 = first line of the message)
help_readman()
{
	echo "$1"
	echo "Please, read the manual for more help about this script"
	echo "Web: http://www.sysresccd.org"
	exit 1
}

## Main
###########################################

if [ "$(basename $0)" == 'usb_inst.sh' ]
then
    RUN_FROM_ISOROOT='1'
    LOCATION="$(dirname ${PROG})"
    PROG_PARTED="${LOCATION}/usb_inst/parted"
    PROG_INSTMBR="${LOCATION}/usb_inst/install-mbr"
    PROG_MKVFATFS="${LOCATION}/usb_inst/mkfs.vfat"
    PROG_SYSLINUX="${LOCATION}/usb_inst/syslinux"
    PROG_DIALOG="${LOCATION}/usb_inst/dialog"
else
    LOCATION="/livemnt/boot"
    PROG_PARTED="$(which parted)"
    PROG_INSTMBR="$(which install-mbr)"
    PROG_MKVFATFS="$(which mkfs.vfat)"
    PROG_SYSLINUX="$(which syslinux)"
    PROG_DIALOG="$(which dialog)"
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
	usage
	exit 1
fi

if [ "$(whoami)" != "root" ]
then
	help_readman "$0: This script requires root privileges to operate."
fi

if [ -z "${RUN_FROM_ISOROOT}" ] && ! cat /proc/mounts | awk '{print $2}' | grep -q -F '/memory'
then
	help_readman "$0: This script must be executed from SystemRescueCd"
	exit 1
fi

if [ -n "${RUN_FROM_ISOROOT}" ] && [ -z "${1}" ]
then
    COMMAND='dialog'
else
    COMMAND="${1}"
    shift
fi

## ERROR HANDLING
#####################################

die()
{
	if [ -n "$1" ]
	then
		echo "$(basename ${PROG}): error: $1"
	else
		echo "$(basename ${PROG}): aborting."
	fi
	exit 1
}

## MISC FUNCTIONS: Many utilities functions
###########################################

# check that there is one partition and one only on block-device $1
find_first_partition()
{
	devname="$1"
	if [ -z "${devname}" ] || [ ! -d "/sys/block/$(basename ${devname})" ]
	then
		die "${devname} is not a valid device name (1)"
	fi
	
	partcnt=0
	firstpart=0
	for i in $(seq 1 4)
	do
		partname="${devname}${i}"
		if [ -b "${partname}" ]
		then
			[ "${firstpart}" = '0' ] && firstpart="$i"
			partcnt=$((partcnt+1))
		fi
	done
	
	if [ "${partcnt}" = '1' ]
	then
		return ${partcnt}
	else
		return 0
	fi
}

# check $1 is a valid partition name
check_valid_partname()
{
	if [ -z "${partname}" ]
	then
		die "you have to provide a valid partition device-name as argument of this command"
	fi

	if [ -z "${partname}" ] || [ ! -b "${partname}" ]
	then
		die "${partname} is not a valid partition name"
	fi
	
	if ! echo "${partname}" | grep -qE '^/dev/[a-z]*[1-4]+$'
	then
		die "device [${partname}] is not a valid partition. Expect something like [/dev/sdf1]"
	fi

	if is_dev_mounted "${partname}"
	then
		die "${partname} is already mounted, cannot continue"
	fi
	
	return 0
}

# check $1 is a valid block device name
check_valid_blkdevname()
{
	if [ -z "${devname}" ]
	then
		die "you have to provide a valid device name as argument of this command"
	fi
	
	if [ ! -b "${devname}" ] || [ ! -d "/sys/block/$(basename ${devname})" ]
	then
		die "${devname} is not a valid device name (2)"
	fi
	
	if is_dev_mounted "${devname}"
	then
		die "${devname} is already mounted, cannot continue"
	fi
	
	return 0
}

check_sysresccd_files()
{
    rootdir="$1"
    [ -z "${rootdir}" ] && die "invalid rootdir"
	for curfile in ${cdfiles[*]}
	do
		curcheck="${rootdir}/${curfile}"
		if ! ls ${curcheck} >/dev/null 2>&1
		then
			die "Cannot find ${curcheck}, cannot continue"
		fi
	done
	return 0
}

# returns 0 if the device is big enough
check_sizeof_dev()
{
	devname="$1"

	if [ -z "${devname}" ]
	then
		die "check_sizeof_dev(): devname is empty"
	fi

	if [ -z "$(which blockdev)" ]
	then
		echo "blockdev not found, assuming the size is ok"
		return 0
	fi
	
	secsizeofdev="$(blockdev --getsz ${devname})"
	mbsizeofdev="$((secsizeofdev/2048))"
	if [ "${mbsizeofdev}" -lt "${MINSIZEMB}" ]
	then
		die "The device [${devname}] is only ${mbsizeofdev} MB. It is too small to copy all the files, an USB-stick of at least ${MINSIZEMB}MB is recommended"
	else
		echo "The device [${devname}] seems to be big enough: ${mbsizeofdev} MB."
		return 0
	fi
}

# say how much freespace there is on a mounted device
check_disk_freespace()
{
	freespace=$(\df -m -P ${1} | grep " ${1}$" | tail -n 1 | awk '{print $4}')
	echo "Free space on ${1} is ${freespace}MB"
	if [ "${freespace}" -lt "${MINSIZEMB}" ]
	then
		die "There is not enough free space on the USB-stick to copy the SystemRescuecd files."
	fi
	return 0
}

# check that device $1 is an USB-stick
is_dev_usb_stick()
{
	curdev="$1"
	
	remfile="/sys/block/${curdev}/removable"
	vendor="$(cat /sys/block/${curdev}/device/vendor 2>/dev/null)"
	model="$(cat /sys/block/${curdev}/device/model 2>/dev/null)"
	if [ -f "${remfile}" ] && cat ${remfile} 2>/dev/null | grep -qF '1' \
		&& cat /sys/block/${curdev}/device/uevent 2>/dev/null | grep -qF 'DRIVER=sd'
	then
		return 0
	else
		return 1
	fi
}

do_writembr()
{
	devname="$1"
	shortname="$(echo ${devname} | sed -e 's!/dev/!!g')"
	
	check_valid_blkdevname "${devname}"
	if ! is_dev_usb_stick "${shortname}"
	then
		die "Device [${devname}] does not seem to be an usb-stick. Cannot continue."
	fi
	
	check_sizeof_dev "${devname}"
	
	if [ ! -x "${PROG_INSTMBR}" ] || [ ! -x "${PROG_PARTED}" ]
	then
		die "install-mbr and parted must be installed, check these programs first."
	fi
	
	cmd="${PROG_INSTMBR} ${devname} --force"
	echo "--> ${cmd}"
	if ! ${cmd}
	then
		die "${cmd} --> failed"
	fi
	
	cmd="${PROG_PARTED} -s ${devname} mklabel msdos"
	echo "--> ${cmd}"
	if ! ${cmd} 2>/dev/null
	then
		die "${cmd} --> failed"
	fi
	
	cmd="${PROG_PARTED} -s ${devname} mkpart primary 0 100%"
	echo "--> ${cmd}"
	if ! ${cmd} 2>/dev/null
	then
		die "${cmd} --> failed"
	fi
	
	cmd="${PROG_PARTED} -s ${devname} set 1 boot on"
	echo "--> ${cmd}"
	if ! ${cmd} 2>/dev/null
	then
		die "${cmd} --> failed"
	fi
}

do_format()
{
	partname="$1"
	check_valid_partname "${partname}"

	check_sizeof_dev "${partname}"

	if [ ! -x "${PROG_MKVFATFS}" ]
	then
		die "mkfs.vfat not found on your system, please install dosfstools first."
	fi
	
	if ${PROG_MKVFATFS} -F 32 -n SYSRESC ${partname}
	then
		echo "Partition ${partname} has been successfully formatted"
		return 0
	else
		echo "Partition ${partname} cannot be formatted"
		return 1
	fi
}

do_copyfiles()
{
	partname="$1"
	check_valid_partname "${partname}"
	
	# check the important files are available in ${LOCATION}
	check_sysresccd_files "${LOCATION}"
	
	check_sizeof_dev "${partname}"
	
	mkdir -p /mnt/usbstick 2>/dev/null
	if ! mount -t vfat ${partname} /mnt/usbstick
	then
		die "cannot mount ${partname} on /mnt/usbstick"
	fi
	echo "${partname} successfully mounted on /mnt/usbstick"
	
	check_disk_freespace "/mnt/usbstick"
	
	if cp -r --remove-destination ${LOCATION}/* /mnt/usbstick/ && sync
	then
		echo "Files have been successfully copied to ${partname}"
	else
		echo "Cannot copy files to ${partname}"
	fi
	
	if ! ls -l /mnt/usbstick/???linux/???linux.cfg >/dev/null 2>&1
	then
		umount /mnt/usbstick
		die "isolinux/syslinux configuration file not found, cannot continue"
	fi
	
	# check the important files have been copied
	check_sysresccd_files "/mnt/usbstick"
	
	# move isolinux files to syslinux files
	if [ -f /mnt/usbstick/isolinux/isolinux.cfg ]
	then
		[ -d /mnt/usbstick/syslinux ] && rm -rf /mnt/usbstick/syslinux
		if ! mv /mnt/usbstick/isolinux/isolinux.cfg /mnt/usbstick/isolinux/syslinux.cfg \
			|| ! mv /mnt/usbstick/isolinux /mnt/usbstick/syslinux
		then
			umount /mnt/usbstick
			die "cannot move isolinux to syslinux, failed"
		fi
	fi
	
	# add scandelay option which allows the usb devices to be detected
	sed -i -e 's!scandelay=1!scandelay=5!g' /mnt/usbstick/syslinux/syslinux.cfg
	
	umount /mnt/usbstick
}

do_syslinux()
{
	partname="$1"
	check_valid_partname "${partname}"
	
	if [ ! -x "${PROG_SYSLINUX}" ]
	then
		die "syslinux not found on your system, please install syslinux first."
	fi
	
	if ${PROG_SYSLINUX} ${partname} && sync
	then
		echo "syslinux has successfully prepared ${partname}"
	else
		echo "syslinux failed to prepare ${partname}"
	fi
}

is_dev_mounted()
{
	curdev="$1"
	
	if cat /proc/mounts | grep -q "^${curdev}"
	then
		return 0
	else
		return 1
	fi
}

do_dialog()
{
    if [ ! -x ${PROG_DIALOG} ]
    then
        die "Program dialog not found, cannot run the semi-graphical installation program"
    fi
	lwselection="$(mktemp /tmp/lwselection.XXXX)"
	selection='${PROG_DIALOG} --backtitle "Select USB-Stick" --checklist "Select USB-Stick (current data will be lost)" 20 70 5'
	devcnt=0
	for curpath in /sys/block/*
	do
		curdev="$(basename ${curpath})"
		devname="/dev/${curdev}"
		if is_dev_usb_stick ${curdev}
		then
			if [ -n "$(which blockdev)" ]
			then
				secsizeofdev="$(blockdev --getsz /dev/${curdev})"
				mbsizeofdev="$((secsizeofdev/2048))"
				sizemsg=" and size=${mbsizeofdev}MB"
			fi
			echo "Device [${devname}] detected as [${vendor} ${model}] is removable${sizemsg}"
			if is_dev_mounted "${devname}"
			then
				echo "Device [${devname}] is mounted: cannot use it"
			else
				echo "Device [${devname}] is not mounted"
				selection="$selection \"${devname}\" \"[${vendor} ${model}] ${sizemsg}\" off"
				devcnt=$((devcnt+1))
			fi
		fi
	done
	if [ "${devcnt}" = '0' ]
	then
		echo "No valid USB-stick has been detected."
	else
		eval $selection 2>$lwselection
		if test -s $lwselection
		then
			for devname2 in $(cat $lwselection  | tr -d \" | sort)
			do
				do_writembr ${devname2}
				sleep 5
				find_first_partition ${devname2}
				devname2="${devname2}$?"
				do_format ${devname2}
				do_copyfiles ${devname2}
				do_syslinux ${devname2}
			done
		fi
	fi
	rm -f $lwselection
}

do_listdev()
{
	devcnt=0
	for curpath in /sys/block/*
	do
		curdev="$(basename ${curpath})"
		devname="/dev/${curdev}"
		if is_dev_usb_stick ${curdev}
		then
			if [ -n "$(which blockdev)" ]
			then
				secsizeofdev="$(blockdev --getsz /dev/${curdev})"
				mbsizeofdev="$((secsizeofdev/2048))"
				sizemsg=" and size=${mbsizeofdev}MB"
			fi	
			echo "Device [${devname}] detected as [${vendor} ${model}] is removable${sizemsg}"
			if is_dev_mounted "${devname}"
			then
				echo "Device [${devname}] is mounted"
			else
				echo "Device [${devname}] is not mounted"
			fi
			find_first_partition ${devname}
			firstpart="$?"
			if [ "${firstpart}" != '0' ]
			then
				echo "Device [${devname}] has one partition: ${devname}${firstpart}"
			else
				echo "Cannot identify which partition to use on ${devname}"
			fi
			devcnt=$((devcnt+1))
		fi
	done
	if [ "${devcnt}" = '0' ]
	then
		echo "No USB-stick has been detected."
	fi
}

## MAIN SHELL FUNCTION
########################################################

case "${COMMAND}" in
	listdev)
		do_listdev
		;;
	writembr)
		do_writembr "$@"
		;;
	format)
		do_format "$@"
		;;
	copyfiles)
		do_copyfiles "$@"
		;;
	syslinux)
		do_syslinux "$@"
		;;
	dialog)
		do_dialog "$@"
		;;
	*)
		usage
		exit 1
		;;
esac
exit 0
