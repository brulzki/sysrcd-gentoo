import re,commands

def probe_filesystem(part):
	try:
		fpart=open(part,'rb')

		# try ntfs
		fpart.seek(3); magic=fpart.read(4)
		if magic=='NTFS':
			return 'ntfs'

		# try ext2/ext3
		fpart.seek(1080); magic=fpart.read(2)
		if magic=='\x53\xEF':
			return 'ext2/ext3'

		# try reiserfs
		fpart.seek(65536+52); magic=fpart.read(10)
		if magic[0:9]=='ReIsEr2Fs' or magic[0:8]=='ReIsErFs':
			return 'reiser3'

		# try lvm2-pv
		fpart.seek(512); magic1=fpart.read(8)
		fpart.seek(536); magic2=fpart.read(4)
		if magic1=='LABELONE' and magic2=='LVM2':
			return 'lvm2'

		# try swap
		fpart.seek(4096-10)
		magic1=fpart.read(10)
		fpart.seek(8192-10)
		magic2=fpart.read(10)
		swapmagics=('SWAP-SPACE', 'SWAPSPACE2')
		if magic1 in swapmagics or magic2 in swapmagics:
			return 'swap'
		
		fpart.close()
		return 'unknown'
	except:
		return 'unknown'

def format(devname, filesys, label, attrib):
	cmdargs=[]
	if filesys=='ext2fs' or filesys=='ext3fs':
		cmdargs.append('mke2fs %s'%devname)
		if filesys=='ext3fs': cmdargs.append('-j')
		if label and re.match('^[0-9A-Za-z/]*$',label): cmdargs.append('-L '+label)
		if attrib: cmdargs.append('-O '+attrib)
	elif filesys[0:9]=='reiser-3':
		cmdargs.append('mkreiserfs %s '%devname)
		if label and re.match('^[0-9A-Za-z/]*$',label): cmdargs.append('-l '+label)
	elif filesys[0:4]=='swap':
		return 0
		# TODO: mkswap does not work on an LVM-LV
		#cmdargs.append('mkswap %s '%devname)
		#if label and re.match('^[:alnum:]*$',label): cmdargs.append('-L '+label)
	if len(cmdargs)==0:
		return -1
	cmdtxt=' '.join(cmdargs)
	print 'mkfs: %s'%cmdtxt
	(st,out)=commands.getstatusoutput (cmdtxt)
	return st

def get_details_ext2(part):
	(status, output) = commands.getstatusoutput ('dumpe2fs -h %s' % part)
	dico={}
	for line in output.splitlines():
		data=line.strip("\r\n").strip().split(':')
		if len(data) == 2:
			dico[data[0].strip()]=data[1].strip()

	# --- copy volume name
	curfeatures=dico['Filesystem features'].split(' ')
	if 'has_journal' in curfeatures:
		filesys='ext3fs'
	else:
		filesys='ext2fs'

	# --- copy volume name
	label=dico['Filesystem volume name']
	
	# --- copy features list
	tmpfeatures=[]
	for possiblefeatures in ('dir_index', 'filetype', 'has_journal', 'journal_dev', 'resize_inode', 'sparse_super'):
		curfeatures=dico['Filesystem features'].split(' ')
		if possiblefeatures in curfeatures:
			tmpfeatures.append(possiblefeatures)
	features=','.join(tmpfeatures)
	
	return (filesys, label, features)

def get_details_ntfs(part):
	(status, output) = commands.getstatusoutput ('ntfsinfo -m %s' % part)
	dico={}
	for line in output.splitlines():
		data=line.strip("\r\n").strip().split(':')
		if len(data) == 2:
			dico[data[0].strip()]=data[1].strip()
	label=dico['Volume Name']
	return ('ntfs', label, '<none>')

def get_details_reiser3(part):
	try:
		fpart=open(part,'rb')

		fpart.seek(65536+100)
		label=fpart.read(16).strip('\x00')

		fpart.seek(65536+52)
		magic=fpart.read(10)

		if magic[0:9]=='ReIsEr2Fs':
			filesys='reiser-3.6'
		elif magic[0:8]=='ReIsErFs':
			filesys='reiser-3.5'
		else:
			filesys='reiserfs'
		fpart.close()
		return (filesys, label, '<none>')
	except:
		return ('reiser3','unknown', '<none>')

def get_details_swap(part):
	try:
		fpart=open(part,'rb')

		fpart.seek(1052)
		label=fpart.read(16).strip('\x00')

		fpart.seek(4096-10)
		magic1=fpart.read(10)
		fpart.seek(8192-10)
		magic2=fpart.read(10)
		if 'SWAP-SPACE' in (magic1, magic2):
			filesys='swap-v1'
		if 'SWAPSPACE2' in (magic1, magic2):
			filesys='swap-v2'
		
		return (filesys, label, '<none>')
	except:
		return ('swap','unknown', '<none>')
