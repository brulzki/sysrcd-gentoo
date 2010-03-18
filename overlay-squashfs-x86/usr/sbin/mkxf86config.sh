#!/bin/bash

source /etc/profile
source /sbin/functions.sh

# First, get the command line
CMDLINE="$(</proc/cmdline)"

# Most of this if for MIPS, except for the last one, which is for everything 
# else to select a default resolution.  Since the MIPS configs are ready to be
# used by default, we exit after calling a MIPS config.
for x in ${CMDLINE}
do
	case "${x}" in
		ip22)
			# Newport for now, IP22 Impact later
			if [ ! -z "$(grep 'SGI Indigo2' /proc/cpuinfo)" ]
			then
				sed -e '/^#@@@/s:\(^#@@@\|@@@$\)::g' \
					/etc/X11/xorg.conf.newport > /etc/X11/xorg.conf
			fi
			exit 0
		;;
		ip28)
			# This might support Newport too, but I2 Newport boards are rare.
			cp -f /etc/X11/xorg.conf.impact /etc/X11/xorg.conf
			exit 0
		;;

		ip30)
			# Figure out if we're Impact, or VPro (Odyssey)
			if [ -e "/proc/fb" ]; then
				ip30_impact="$(grep -i 'impact' /proc/fb)"
				ip30_odyssey="$(grep -i 'odyssey' /proc/fb)"
				if [ -n "${ip30_impact}" ]
				then
					cp -f /etc/X11/xorg.conf.impact /etc/X11/xorg.conf
				elif [ -n "${ip30_odyssey}" ]
				then
					# Do nothing for now -- maybe one day we'll get an X driver
					# cp -f /etc/X11/xorg.conf.odyssey /etc/X11/xorg.conf
					ewarn "Currently, there is no X driver for Odyssey"
				fi
			fi
			exit 0
		;;
		ip32)
			# We use fbdev for now -- maybe one day we'll get a gbefb X driver
			cp -f /etc/X11/xorg.conf.o2-fbdev /etc/X11/xorg.conf
			exit 0
		;;
		xres\=*)
			# We got a resolution on the command line, use it.
			NEWMODE=$(echo ${x} | cut -d= -f2)
			RAWMODES="\"${NEWMODE}\""
	esac
done

TMPFILE="/tmp/mkxf86config-$$"
MONITORTMP="${TMPFILE}-monitor"

rm -f "${TMPFILE}" "${MONITORTMP}"

# Read in what hwsetup has found for X
[ -f /etc/sysconfig/xserver ] && . /etc/sysconfig/xserver

WHEEL='s|"PS/2"|"auto"\
Option          "ZAxisMapping"          "4 5"|g;'

# Read in changes
[ -f /etc/sysconfig/gentoo ] && . /etc/sysconfig/gentoo

# Read default keyboard from config file.
# There seems to be no reliable autoprobe possible.
[ -f /etc/sysconfig/keyboard ] && . /etc/sysconfig/keyboard

# Create mouse link and insert a mouse default type into xorg.conf
# if not already done by hwsetup
[ -f /etc/sysconfig/mouse ] && . /etc/sysconfig/mouse
# We create this link since hwsetup cannot properly detect serial mice
[ -e /dev/mouse ] || ln -sf /dev/ttyS0 /dev/mouse

PROTO="${XMOUSETYPE:-Microsoft}"
NOEMU=""
[ "${XEMU3}" = "no" ] && NOEMU='s|^.*Emulate3|# No 2 -> 3 Button emulation|g'

DEADKEYS=""
[ "${XKEYBOARD}" = "de" ] || DEADKEYS='s|^.*nodeadkeys.*$||g;'

if [ -n "${XMODULE}" ]
then
	# Check for Framebuffer X-Modules and initialize framebuffer module
	case "${XMODULE}" in
		pvr2fb)
			modprobe "${XMODULE}" >/dev/null 2>&1
			XMODULE="fbdev"
		;;
	esac
fi

# We used to use ddcxinfo-knoppix for monitor information, now we will just let
# X choose for itself.  This will probably break older machines.
# You can uncomment the following to re-enable dccxinfo-knoppix, but this only
# works on x86.
#MONITOR="$(ddcxinfo-knoppix -monitor)"
# Here we are setting a default set of HorizSync and VertRefresh.  These are
# "safe" values.  I am hoping to remove this completely in the future once more
# testing has been done on alternate architectures.
MONITOR='Section "Monitor"
	Identifier   "Monitor0"
	HorizSync    28.0 - 96.0
	VertRefresh  50.0 - 75.0
EndSection'
RC="$?"
COMPLETE="$(awk '/EndSection/{print}' <<EOF
${MONITOR}
EOF
)"

# Extract values for display
MODEL="$(awk '/^[	 ]*ModelName/{print;exit}'<<EOF
${MONITOR}
EOF
)"

MODEL="${MODEL#*\"}"
MODEL="${MODEL%\"*}"

HREFRESH="$(awk '/^[	 ]*HorizSync/{print $2 $3 $4; exit}'<<EOF
${MONITOR}
EOF
)"

VREFRESH="$(awk '/^[	 ]*VertRefresh/{print $2 $3 $4; exit}'<<EOF
${MONITOR}
EOF
)"

# Build line of allowed modes
# This is created from the Modelines created by ddcxinfo-knoppix and is not
# always accurate for your monitor.  This is currently set statically to give
# working support for alpha/amd64/ppc/x86 for the 2007.0 Gentoo release.  If
# anyone has more reliable, cross-platform methods, I'm all ears.
#RAWMODES=$(ddcxinfo-knoppix -monitor | grep ModeLine | sed -r "s/.*\"([0-9]+x[0-9]+)\".*/\1/g"| sort -rg | uniq | xargs echo | sed -r "s/([0-9]+x[0-9]+)/\"\1\"/g")
[ -z "${RAWMODES}" ] && RAWMODES="\"1024x768\" \"800x600\" \"640x480\""
MODES="Modes ${RAWMODES}"

# We need to check this because serial mice have long timeouts
SERIALMOUSE="$(ls -l1 /dev/mouse* 2>/dev/null | awk '/ttyS/{print $NF ; exit 0}')"
if [ -n "${SERIALMOUSE}" ]
then
	SERIALMOUSE="s|/dev/ttyS0|${SERIALMOUSE}|g;"
else
	SERIALMOUSE='s|^.*InputDevice.*"Serial Mouse".*$|# Serial Mouse not detected|g;'
fi

# PS/2 bug: Some keyboards are incorrectly used as mice in XFree. :-(
PSMOUSE="$(ls -l1 /dev/mouse* 2>/dev/null | awk '/input/{print $NF ; exit 0}')"
if [ -n "${PSMOUSE}" ]
then
	PSMOUSE=""
else
	PSMOUSE='s|^.*InputDevice.*"PS/2 Mouse".*$|# PS/2 Mouse not detected|g;'
fi

case "$(cat /proc/modules)" in
	*usbmouse*|*mousedev*|*hid\ *)
		USBMOUSE=""
	;;
	*)
		USBMOUSE='s|^.*InputDevice.*"USB Mouse".*$|# USB Mouse not detected|g;'
	;;
esac

# Kernel 2.6 reports psaux via /dev/input/mice like USB
case "$(uname -r)" in
	2.6.*)
		if [ -n "${PSMOUSE}" ]
		then
			PSMOUSE='s|^.*InputDevice.*"PS/2 Mouse".*$|# PS/2 Mouse using /dev/input/mice in Kernel 2.6|g;'
			USBMOUSE=""
		fi
	;;
esac

if [ -a /proc/bus/input/devices ]
then
	CHECK=$(cat /proc/bus/input/devices | grep -i synaptics | wc -l)
	if [ ${CHECK} -gt 0 ]
	then
		modprobe -q evdev
		SYNDEV=/dev/input/$(cat /proc/bus/input/devices | egrep -i -A 5 "^N: .*synaptics.*" | grep Handlers | sed -r "s/.*(event[0-9]+).*/\1/g")
		SYNMOUSE=""
	else
		SYNMOUSE='s|^.*InputDevice.*"Synaptics".*$|#No Synaptics touchpad found|g;'
	fi
fi

# Write Monitor data now
rm -f "${MONITORTMP}"
echo "${MONITOR}" > "${MONITORTMP}"

# Intel drivers have been renamed
if [ "${XMODULE}" = 'i810' ]
then
	XMODULE='intel'
fi

# VMWare special handling
VMWARE=""
MOUSEDRIVER=""
if [ "${XMODULE}" = "vmware" ]
then
	VMWARE='s|^.*BusID.*PCI.*$|BusID "PCI:0:15:0"|g;'
	DEPTH='s|DefaultColorDepth |# DefaultColorDepth |g;'
	if [ -e /usr/lib/xorg/modules/input/vmmouse_drv.so ] || \
	[ -e /usr/lib/modules/input/vmmouse_drv.so ]
	then
		MOUSEDRIVER='s|^.*Driver.*"mouse".*$|\tDriver\t"vmmouse"|g;'
	fi
fi

#VirtualPC special handline
VPC=""
if [ "${XMODULE}" = "s3" ]
then
	VPC='s|^.*BusID.*PCI.*$|BusID "PCI:0:8:0"|g;'
	DEPTH='s|DefaultColorDepth 24|DefaultColorDepth 16|g;'
fi

# If we don't have a XMODULE set, use fbdev as fall-back
#
#[ -z "${XMODULE}" [ -z "${XMODULE}" ] ] && XMODULE="fbdev"] && XMODULE="fbdev" XMODULE="vesa"
[ -z "${XMODULE}" ] && XMODULE="vesa"

# Do NOT use a default colordepth setting if we are using the "fbdev" module
if [ "${XMODULE}" = "fbdev" ]
then
	DEPTH='s|DefaultColorDepth |# DefaultColorDepth |g;'
fi

# These drivers need the sw_cursor option
SWCURSOR=""
MONITORLAYOUT=""
case "${XMODULE}" in
	ati|nv|trident)
		SWCURSOR='s|^.*#Option.*"sw_cursor".*$|Option "sw_cursor"|g;'
	;;
	radeon)
		SWCURSOR='s|^.*#Option.*"sw_cursor".*$|Option "sw_cursor"|g;'
		MONITORLAYOUT='s|^.*#Option.*"MonitorLayout".*$|Option "MonitorLayout"|g;'
	;;
esac

# We must use NoPM, because some machines freeze if Power management is beingi
# activated.
NOPM=""
DPMS=""

#checkbootparam noapm && NOPM='Option	"NoPM"	"true"' || DPMS='Option	"DPMS"	"true"'

sed -e 's|@@PROTOCOL@@|'"${PROTO}"'|g;'"${NOEMU}" \
    -e '/@@MONITOR@@/r '"${MONITORTMP}" \
    -e 's|@@MONITOR@@||g' \
    -e 's|@@NOPM@@|'"${NOPM}"'|g' \
    -e 's|@@XMODULE@@|'"${XMODULE}"'|g;'"${VMWARE}""${VPC}""${SERIALMOUSE}""${USBMOUSE}""${PSMOUSE}""${SWCURSOR}""${MONITORLAYOUT}""${WHEEL}""${SYNMOUSE}""${MOUSEDRIVER}" \
    -e 's|@@SYNDEV@@|'"${SYNDEV}"'|g' \
    -e 's|@@MODES@@|'"${MODES}"'|g;'"${DEPTH}" \
    -e 's|"XkbLayout" *"[^"]*"|"XkbLayout" "'"${XKEYBOARD}"'"|g;'"${DEADKEYS}" \
    /etc/X11/xorg.conf.in >/etc/X11/xorg.conf

if [ -n "${DPMS}" ]
then
    if [ -f /etc/X11/xorg.conf ]
	then
        sed -e 's|Identifier[    ]*"Monitor0"|Identifier        "Monitor0"\
	'"${DPMS}"'|g' /etc/X11/xorg.conf >/etc/X11/xorg.conf.new
		mv -f /etc/X11/xorg.conf.new /etc/X11/xorg.conf
    fi
fi

rm -f "${TMPFILE}" "${MONITORTMP}" 2>/dev/null

# Print info about selected X-Server
[ -n "${XDESC}" ] || XDESC="(yet) unknown card"
echo -n " ${GOOD}Video is"

[ -n "${XDESC}" ] && echo -n " ${HILITE}${XDESC}${NORMAL},"
echo -n " using ${GOOD}${XSERVER:-generic VESA}"
[ -n "${XMODULE}" ] && echo -n "(${HILITE}${XMODULE}${NORMAL})"
echo " Server${NORMAL}"

echo -n " ${GOOD}Monitor is ${HILITE}${MODEL:-Generic Monitor}${NORMAL}"
[ -n "${HREFRESH}" -a -n "${VREFRESH}" ] && echo "${GOOD}, ${GOOD}H:${HILITE}${HREFRESH}kHz${GOOD}, V:${HILITE}${VREFRESH}Hz${NORMAL}" || echo ""
[ -n "${XVREFRESH}" ] && echo " ${GOOD}Trying specified vrefresh rate of ${HILITE}${XVREFRESH}Hz.${NORMAL}"

[ -n "${MODES}" ] && echo " ${GOOD}Using Modes ${HILITE}${MODES##Modes }${NORMAL}"

