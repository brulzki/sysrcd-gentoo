<ALL> 
<ALL> 070FF107 | 0FF207 | 0FF307 | 0FF407 | 0CF507 | 0FF607 | 0FF707      0CSystemRescueCd07        09[troubleshooting]07
<ALL> 
<ALL> This page tells you how to troubleshoot boot problems. Try these options if
<ALL> you cannot boot (error during the kernel initialisation, screen frozen, ... )
<ALL> For more help read the SystemRescueCd manual or find support in the forums:
<ALL> 02www.system-rescue-cd.org/Online-Manual-EN07 and 02http://www.system-rescue-cd.org/forums/07
<ALL> 
<ALL> 0C*07 0EProblems related to storage07 (hard disk / cdrom / usb stick):
<ALL> 0C+07 you can try to disable the DMA speed optimisations: 0Fide=nodma07
<ALL> 0C+07 you can try to use the basic ide driver: 0Fall-generic-ide07
<ALL> 0C+07 wait for devices that are slow to initialize: 0Fscandelay=1507
<ALL> 0C*07 0EIf the boot process stops due to a problem with a driver:07
<ALL> 0C+07 if the driver is compiled as a module, try 0Fnoload=modulename07
<STD> 0C+07 use the alternative kernel: use 0Faltker3207 instead of 0Frescue3207
<ALL> 0C+07 if the hardware autodetection crashes the computer try 0Fnodetect07
<ALL> 0C+07 you can also try this: 0Fnoapic07 or 0Firqpool07 or 0Facpi=off07
<ALL> 0C*07 0EProblems with the X.Org graphical mode (startx does not work):07
<ALL> 0C+07 boot with 0FXvesa07 instead of 0FXorg07, type 0Fwizard07 in the shell to choose
<ALL> 0C+07 you can try to use the old X.Org autoconfiguration: 0Fdoxdetect07
<ALL> 0C+07 use a boot image with no framebuffer (boot with 0Frescue3207)
<ALL> 0C*07 0EOther boot problems:07
<ALL> 0C+07 forces the initramfs to 0Cload any module07 listed: 0Fdoload=X07
<ALL> 0C+07 loads support for 0CSCSI07 and 0CUSB07 devices with 0Fdoscsi07
<ALL> 
