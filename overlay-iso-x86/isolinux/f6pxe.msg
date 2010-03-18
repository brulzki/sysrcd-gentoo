 
070FF107 | 0FF207 | 0FF307 | 0FF407 | 0FF507 | 0CF607 | 0FF707        0CSystemRescueCd07               09[pxe boot]07

This page tells you how to boot SystemRescueCd from the network using PXE. 

For more help read the SystemRescueCd manual or find support in the forums:
02www.sysresccd.org/Online-Manual-EN07

0C*07 0EAbout PXE Network booting07:
  SystemRescueCd provides a PXE-boot-server out of the box. You just have 
  to start a SystemRescueCd from the CD/USB/HDD and configure it to act 
  as a PXE boot server on your local network. The configuration is very
  simple, you just have to write your settings in a config file and start
  the pxebootsrv service and that's it. You can then boot other computer
  with at least 256MB of memory from the network with PXE.
0C*07 0ESteps to use the PXE Network boot feature:07
  0C+07 Boot SystemRescueCd from the CD/USB/HDD on a computer
  0C+07 Configure the network settings with 0Fipconfig07 / 0Froute add07 ...
  0C+07 Edit your pxe/network settings in 0F/etc/conf.d/pxebootsrv07
  0C+07 Start the service with 0F/etc/init.d/pxebootsrv start07
  0C+07 The computer should be ready to act as a PXE boot server
  0C+07 Boot any computer with at least 300MB of RAM with PXE
 
 
 
