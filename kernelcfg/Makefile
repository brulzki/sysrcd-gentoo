all: rescue32 rescue64

rescue32:
	./merge.pl sysrcd-generic.conf config-4.9.15-100.fc24.i686 >| config-std-i686.tmp1
	./merge.pl sysrcd-stdker.conf config-std-i686.tmp1 >| config-std-i686.tmp2
	./merge.pl sysrcd-32bit.conf config-std-i686.tmp2 >| config-std-i686.cfg
	rm -f config*tmp*

rescue64:
	./merge.pl sysrcd-generic.conf config-4.9.15-100.fc24.x86_64 >| config-std-x86_64.tmp1
	./merge.pl sysrcd-stdker.conf config-std-x86_64.tmp1 >| config-std-x86_64.tmp2
	./merge.pl sysrcd-64bit.conf config-std-x86_64.tmp2 >| config-std-x86_64.cfg
	rm -f config*tmp*

