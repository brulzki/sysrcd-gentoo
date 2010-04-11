 
070FF107 | 0FF207 | 0FF307 | 0FF407 | 0FF507 | 0FF607 | 0CF707        0CSystemRescueCd07              09[network]07

This page tells you what boot options related to the network are available. 

0C*07 0EWhy these network boot options07:
You may want to work on a remote computer with SystemRescueCd. For instance
you may have computers in a datacenter that you want to be able to backup
or restore from SystemRescueCd. To do that, you will have to boot this livecd
using the network boot via PXE. To connect to the system, you will need to
set the root password of the system and to set the ip address. Since you 
cannot do this remotely because you need a physical access to the machine,
we provide the following options that prepares the system so that you can
ssh to this machine remotely.

0C*07 0EChange the root password07:
0Frootpass=xxx07 sets the root password of the livecd system at boot time07

0C*07 0ENetwork configuration options07:
0Fethx=xxx    07 configure the IP-address on all the ethernet interfaces found07
0Fgateway=xxx 07 set the default route (route add default gw xxx)07
0Fdns=xxx     07 set the DNS name server for name resolution07
0Fdodhcp      07 runs the DHCP client at boot time to get a dynamic IP07
0Fdhcphostname=xxx   07 hostname sent to the dhcp server by the dhcp client07
 
