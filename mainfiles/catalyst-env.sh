export VIDEO_CARDS="vesa vmware nv radeon cyrix amd ark chips dummy epson glint intel i128 i740 impact imstt mach64 mga neomagic newport nsc r128 rendition s3 s3virge siliconmotion tga trident tseng via sis savage tdfx cirrus radeonhd geode"
export INPUT_DEVICES="keyboard vmmouse mouse evdev synaptics"
export FEATURES="parallel-fetch -collision-protect -protect-owned"
export MAKEOPTS="-j5 --load-average=8"
export PORTAGE_NICENESS="19"
export ACCEPT_LICENSE="*"
export CFLAGS="-Os -mtune=i686 -pipe"
export CXXFLAGS="-Os -mtune=i686 -pipe"
#fglrx is the proprietary driver for ati (can also emerge ati-drivers)
#nv is the free driver for nvidia
#radeon is the free driver for ati
