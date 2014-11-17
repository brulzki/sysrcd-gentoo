<ALL> 
<ALL> 070FF107 | 0FF207 | 0CF307 | 0FF407 | 0FF507 | 0FF607 | 0FF707        0CSystemRescueCd07         09[boot options]07
<ALL> 
<ALL> 0C*07 You can add the following boot options after the image name:
<ALL> You must add these options after the boot image (F2 for images). You can use
<ALL> the default boot image name (0Frescue3207) in most cases. For instance if you
<ALL> want to load the whole system into the memory type this: 0Frescue32 docache07
<ALL> 
<ALL> 0Fdocache07    0Ccopy system in RAM07: you can eject the cd, requires <MEMREQ> of RAM
<ALL> 0Fsetkmap=x07  0Cconfigure the keyboard07 with the x keymap (x='fr', 'de', 'us', ...)
<ALL> 0Froot=x07     0Croot=/dev/sda107 boots from 0F/dev/sda107, 0Croot=auto07 scans the disks
<ALL> 0Fforcevesa07  0Cuse the 0CXvesa07 graphical server instead of 0CXorg07 when you type startx
<ALL> 0Fnoload=x07   0Cprevent a module07 from being loaded at startup (eg: noload=3c59x)
<ALL> 0Fdoload=x07   0Cforce to load one/several modules07 at startup (eg: doload=3c59x)
<ALL> 0Frootpass=x07 sets the 0Croot password07 to x so that you can ssh to the system
<ALL> 0Fethx=ip07    automatically 0Cconfigure the ethernet07 interfaces with an ip address
<ALL> 0Fgateway=ip07 automatically 0Cset the default route07 in the network configuration
<ALL> 0Fdns=ip07     automatically configure the ip address of the 0CDNS server07 to use
<ALL> 0Fdostartx07   Runs the 0Cgraphical environment07 automatically at boot time
<ALL> 0Fminishell07  Run the 0Cdebug shell07 from the initramfs during the boot process
<ALL> 
<ALL> 0C*07 Press 0FF207 for the list of the boot images (use 0Frescue3207 by default)
<ALL> 0C*07 Press 0FF507 for boot options related to boot problems and troubleshooting.
<ALL> 0C*07 Press 0FF707 for the list of the other options related to the network
<ALL> 
