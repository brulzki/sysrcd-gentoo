import re,os,commands,sys,datetime

# Parse /proc/partitions and display a list of the physical hard disks found
def list_disks():
	res=[]
	for curl in file('/proc/partitions'):
		if re.match('^$',curl) or re.match('^major',curl): continue
		devname=curl.strip("\r\n").split()[3]
		testfile='/sys/block/%s' % devname.replace('/','!')
		if os.path.isdir(testfile) and (devname[0:2] != 'dm') and (devname[0:4] != 'loop'):
			res.append(devname)
	return res

# Parse /proc/partitions and display a list of the partitions
def list_partitions():
	res=[]
	for curl in file('/proc/partitions'):
		if re.match('^$',curl) or re.match('^major',curl): continue
		devname=curl.strip("\r\n").split()[3]
		testfile='/sys/block/%s' % devname.replace('/','!')
		if not os.path.isdir(testfile) and (devname[0:2] != 'dm') and (devname[0:4] != 'loop'):
			res.append(devname)
	return res
	
def finddir(rootdir, filename):
	for root, dirs, files in os.walk(rootdir, topdown=False):
		for name in dirs:
			if name==filename:
				return os.path.join(root, name)
	return ''

# return size of the partition using /sys/block
def get_part_size(part):
	infofile=finddir('/sys/block', part)+'/size'
	size=int(file(infofile).read())*512
	return size

def format_size(size):
	units=('B', 'KB', 'MB', 'GB', 'TB')
	curunit=0
	while size >= 1024:
		size=float(size)/1024.0
		curunit+=1
	if curunit==0:
		return '%4d %s'%(size, units[curunit])
	else:
		return '%4.2f %s'%(size, units[curunit])
