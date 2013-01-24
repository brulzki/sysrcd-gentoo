all: rescue32 rescue64 altker32 altker64

rescue32:
	./merge.pl sysrcd-generic.conf config-3.4.12-1.fc16.i686 >| config-std-i586.tmp1
	./merge.pl sysrcd-stdker.conf config-std-i586.tmp1 >| config-std-i586.tmp2
	./merge.pl sysrcd-32bit.conf config-std-i586.tmp2 >| config-std-i586.cfg
	rm -f config*tmp*

rescue64:
	./merge.pl sysrcd-generic.conf config-3.4.12-1.fc16.x86_64 >| config-std-x86_64.tmp1
	./merge.pl sysrcd-stdker.conf config-std-x86_64.tmp1 >| config-std-x86_64.tmp2
	./merge.pl sysrcd-64bit.conf config-std-x86_64.tmp2 >| config-std-x86_64.cfg
	rm -f config*tmp*

altker32:
	./merge.pl sysrcd-generic.conf config-3.7.3-101.fc17.i686 >| config-alt-i586.tmp1
	./merge.pl sysrcd-altker.conf config-alt-i586.tmp1 >| config-alt-i586.tmp2
	./merge.pl sysrcd-32bit.conf config-alt-i586.tmp2 >| config-alt-i586.cfg
	rm -f config*tmp*

altker64:
	./merge.pl sysrcd-generic.conf config-3.7.3-101.fc17.x86_64 >| config-alt-x86_64.tmp1
	./merge.pl sysrcd-altker.conf config-alt-x86_64.tmp1 >| config-alt-x86_64.tmp2
	./merge.pl sysrcd-64bit.conf config-alt-x86_64.tmp2 >| config-alt-x86_64.cfg
	rm -f config*tmp*

