subarch: i486
version_stamp: full
target: stage4
rel_type: default
profile: default/linux/x86/13.0
snapshot: 20130301
source_subpath: default/stage3-i486-20121213
portage_confdir: /worksrc/sysresccd-src/portage-etc-x86
portage_overlay: /worksrc/sysresccd-src/portage-overlay

stage4/use: sysrcdfull X consolekit icu gtk gtk2 -svg -opengl -glx -berkdb -gdbm -minimal -introspection dri bindist fbcon ipv6 livecd ncurses pam readline ssl unicode zlib nptl nptlonly multilib multislot jfs ntfs reiserfs xfs fat reiser4 samba png jpeg xorg usb pdf acl nologin atm bash-completion slang -kdrive vram loop-aes crypt device-mapper 7zip xattr bzip2 server lzo xpm bash-completion -fam -doc -hardened -spoof-source -static -tcpd -mailwrapper -milter -nls -selinux -ermt -pic -dar32 -dar64 -openct -pcsc-lite -smartcard -caps -qt3 -qt4 -aqua -cscope -gnome -gpm -motif -netbeans -nextaw -perl -python -ruby -xterm -emacs -justify -spell -vim-pager -vim-with-x -sqlite -afs -bashlogger -plugins -vanilla -examples -maildir pcre -accessibility -ithreads -perlsuid -php -pike -tcl -tk -nocxx -no-net2 -kerberos -sse2 -aio -cups -ldap -quotas -swat -syslog -winbind -socks5 -guile -X509 dbus -gnutls -gsm -cracklib -nousuid -skey -old-linux -pxeserial -multitarget -test -clvm -cman -gulm -gd -glibc-compat20 -glibc-omitfp -bidi -xinerama -qt3support -alsa -xcb nfsv4 -gallium -fortran

stage4/packages:
	app-arch/lbzip2
	app-editors/vim
	app-portage/eix
	app-portage/gentoolkit
	app-shells/zsh
	<dev-lang/python-2.7.999
	sys-libs/cracklib
	dev-libs/icu
	dev-libs/libxml2
	dev-perl/XML-LibXML
	dev-perl/XML-Parser
	dev-perl/XML-SAX-Base
	dev-perl/YAML-Syck
	perl-core/File-Spec
	sys-apps/file
	sys-devel/gcc
	sys-devel/autoconf
	sys-devel/autogen
	sys-devel/automake
	sys-devel/libtool
	sys-fs/udev
	sys-fs/udev-init-scripts

stage4/fsscript:
	/worksrc/sysresccd-src/mainfiles/fsscript-stage4.sh

