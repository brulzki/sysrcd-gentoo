<ALL> 
<ALL> 070FF107 | 0FF207 | 0FF307 | 0FF407 | 0FF507 | 0CF607 | 0FF707        0CSystemRescueCd07             09[pxe boot]07
<ALL> 
<ALL> This page tells you how to boot SystemRescueCd from the network using PXE.
<ALL> 
<ALL> For more help read the SystemRescueCd manual or find support in the forums:
<ALL> 02www.system-rescue-cd.org/Online-Manual-EN07
<ALL> 
<ALL> 0C*07 0EAbout PXE Network booting07:
<ALL> SystemRescueCd provides a PXE-boot-server out of the box. You just have
<ALL> to start a SystemRescueCd from the CD/USB/HDD and configure it to act
<ALL> as a PXE boot server on your local network. The configuration is very
<ALL> simple, you just have to write your settings in a config file and start
<ALL> the pxebootsrv service and that's it. You can then boot other computer
<ALL> with at least <MEMREQ> of memory from the network with PXE.
<ALL> 0C*07 0ESteps to use the PXE Network boot feature:07
<ALL> 0C+07 Boot SystemRescueCd from the CD/USB/HDD on a computer
<ALL> 0C+07 Configure the network settings with 0Fipconfig07 / 0Froute add07 ...
<ALL> 0C+07 Edit your pxe/network settings in 0F/etc/conf.d/pxebootsrv07
<ALL> 0C+07 Start the service with 0F/etc/init.d/pxebootsrv start07
<ALL> 0C+07 The computer should be ready to act as a PXE boot server
<ALL> 0C+07 Boot any computer with at least <MEMREQ> of RAM with PXE
<ALL> 
<ALL> 
<ALL> 
