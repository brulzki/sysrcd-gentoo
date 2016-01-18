##############################################################################
#                                                                            #
# Project page: http://www.system-rescue-cd.org/                                    #
# (C) 2013 Francois Dupoux                                                   #
#                                                                            #
###############################################################################

You may want to modify the CDRom version of SystemRescueCd (ISO image file).
This can be useful in order to add your own script or SRM files 
(SystemRescueCd modules: http://www.system-rescue-cd.org/Modules). Module provide
support for extra programs which are not included in the standard version.

There are two ways to customize the ISO image of SystemRescueCd:
*) Windows users can use the SystemRescueCd installer for Windows
*) Linux users can recreate the ISO image using xorriso
   A static xorriso can be found in the CDRom/ISO image in usb_inst

In both cases the contents of the original CDRom/ISO will be copied to a 
temp directory on the hard disk. You can then make your own changes in
this directory and the new ISO image file has to be recreated, using
either the SystemRescueCd installer on Windows or xorriso on Linux.

*) Customization of the ISO image on Windows
   Download the latest version of the SystemRescueCd installer for Windows
   and just follow the instructions

*) Customization of the ISO image on Linux
   a) Mount the ISO image to a directory such as /media
      # mount -o loop,ro /var/tmp/systemrescuecd-x86-x.y.z.iso /media
   b) Copy all files from the mount point to a temp directory
      # cp -a /media /var/tmp/sysrcd
   c) Copy the extra SRM module files (or make other changes)
      # cp -a ~/mymodule.srm /var/tmp/sysrcd/mymodule.srm
      # md5sum /var/tmp/sysrcd/mymodule.srm > /var/tmp/sysrcd/mymodule.md5
   d) Recreate the ISO Image
      # xorriso -as mkisofs -joliet -rock \
                -omit-version-number -disable-deep-relocation \
                -b isolinux/isolinux.bin -c isolinux/boot.cat \
                -no-emul-boot -boot-load-size 4 -boot-info-table \
                -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot \
                -volid MyRescueCd -o /var/tmp/sysrcd-custom.iso /var/tmp/sysrcd

