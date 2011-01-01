all: rescuecd rescue64 altker32 altker64

rescuecd:
	./merge.pl sysrcd-generic.conf config-2.6.35.10-67.fc14.i686 >| config-2.6.35-std200.i686.tmp
	./merge.pl sysrcd-stdker.conf config-2.6.35-std200.i686.tmp >| config-2.6.35-std200.i686
	rm -f config-2.6.35-std200.i686.tmp

rescue64:
	./merge.pl sysrcd-generic.conf config-2.6.35.10-67.fc14.x86_64 >| config-2.6.35-std200.x86_64.tmp
	./merge.pl sysrcd-stdker.conf config-2.6.35-std200.x86_64.tmp >| config-2.6.35-std200.x86_64
	rm -f config-2.6.35-std200.x86_64.tmp

altker32:
	./merge.pl sysrcd-generic.conf config-2.6.36.2-12.fc15.i686 >| config-2.6.36-alt200.i686.tmp
	./merge.pl sysrcd-altker.conf config-2.6.36-alt200.i686.tmp >| config-2.6.36-alt200.i686
	rm -f config-2.6.36-alt200.i686.tmp

altker64:
	./merge.pl sysrcd-generic.conf config-2.6.36.2-12.fc15.x86_64 >| config-2.6.36-alt200.x86_64.tmp
	./merge.pl sysrcd-altker.conf config-2.6.36-alt200.x86_64.tmp >| config-2.6.36-alt200.x86_64
	rm -f config-2.6.36-alt200.x86_64.tmp

