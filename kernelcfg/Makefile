all: rescuecd rescue64 altker32 altker64

rescuecd:
	./merge.pl sysrcd-generic.conf config-2.6.35.12-88.fc14.i686 >| config-2.6.35-std210.i586.tmp1
	./merge.pl sysrcd-stdker.conf config-2.6.35-std210.i586.tmp1 >| config-2.6.35-std210.i586.tmp2
	./merge.pl sysrcd-32bit.conf config-2.6.35-std210.i586.tmp2 >| config-2.6.35-std210.i586
	rm -f config*tmp*

rescue64:
	./merge.pl sysrcd-generic.conf config-2.6.35.12-88.fc14.x86_64 >| config-2.6.35-std210.x86_64.tmp
	./merge.pl sysrcd-stdker.conf config-2.6.35-std210.x86_64.tmp >| config-2.6.35-std210.x86_64
	rm -f config*tmp*

altker32:
	./merge.pl sysrcd-generic.conf config-2.6.38.2-8.fc15.i686 >| config-2.6.38-alt210.i586.tmp1
	./merge.pl sysrcd-altker.conf config-2.6.38-alt210.i586.tmp1 >| config-2.6.38-alt210.i586.tmp2
	./merge.pl sysrcd-32bit.conf config-2.6.38-alt210.i586.tmp2 >| config-2.6.38-alt210.i586
	rm -f config*tmp*

altker64:
	./merge.pl sysrcd-generic.conf config-2.6.38.2-8.fc15.x86_64 >| config-2.6.38-alt210.x86_64.tmp
	./merge.pl sysrcd-altker.conf config-2.6.38-alt210.x86_64.tmp >| config-2.6.38-alt210.x86_64
	rm -f config*tmp*

