Sysrcd-Gentoo
=============

This is a fork from System Rescue CD 5.3.2, the last gentoo-based version of System Rescue CD.

Dependencies
------------

The following packages must be install in the build environment.

- dev-util/catalyst
- sys-kernel/genkernel
- sys-boot/grub
- app-arch/cpio
- app-arch/pixz
- dev-libs/libisoburn

Building
--------

> `sudo ./build.sh`

This script prepares the necessary build area in `/worksrc`, which is used during the building process. Then the catalyst stages are invoked, the kernels are built and finally the iso image is generated.
