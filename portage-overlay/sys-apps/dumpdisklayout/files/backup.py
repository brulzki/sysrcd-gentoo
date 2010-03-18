import sys,os
sys.path.append(os.path.abspath(os.curdir))
sys.path.append('/usr/lib/dumpdisklayout/modules/')
import re,commands,sys,datetime
import mod_checks
import mod_filesys
import mod_diskutil
import mod_lvm

FILEFORMVER='0.1.1'

# -------------------------- worker functions --------------------------
def dump_sysinfo():
	reslines=[]
	reslines.append("fileformat!%s" % FILEFORMVER)
	reslines.append("datetime!%s" % datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
	reslines.append("hostname!%s" % commands.getstatusoutput('uname -n')[1])
	reslines.append("sysname!%s" % commands.getstatusoutput('uname -s')[1])
	reslines.append("sysrelease!%s" % commands.getstatusoutput('uname -r')[1])
	reslines.append("arch!%s" % commands.getstatusoutput('uname -m')[1])
	return reslines

def dump_disks():
	reslines=[]
	for dev in mod_diskutil.list_disks():
		size=file('/sys/block/%s/size'%dev).readline().strip("\r\n").strip()
		vendor=file('/sys/block/%s/device/vendor'%dev).readline().strip("\r\n").strip()
		model=file('/sys/block/%s/device/model'%dev).readline().strip("\r\n").strip()
		reslines.append("%s!%s!%s!%s" % (dev,size,vendor,model))
	return reslines

def dump_sfdisk():
	reslines=[]
	for dev in mod_diskutil.list_disks():
		cmd="sfdisk -d /dev/%s" % dev
		(status, output) = commands.getstatusoutput(cmd)
		if status != 0: continue
		for line in output.splitlines():
			reslines.append("%s!%s" % (dev, line))
	return reslines

def dump_pv():
	reslines=[]
	for pv in mod_lvm.list_pv():
		data=mod_lvm.get_pv_details(pv)
		reslines.append("%s" % ('!'.join(data)))
	return reslines

def dump_vg():
	reslines=[]
	for vg in mod_lvm.list_vg():
		data=mod_lvm.get_vg_details(vg)
		data.append(mod_lvm.get_vg_format(vg))
		reslines.append("%s" % ('!'.join(data)))
	return reslines

def dump_lv():
	reslines=[]
	for lv in mod_lvm.list_lv():
		data=mod_lvm.get_lv_details(lv)
		reslines.append("%s" % ('!'.join(data)))
	return reslines

def dump_fs():
	reslines=[]
	
	# get list of filesystems containers (LVM-LV of partition not PV)
	fscontainers=mod_lvm.list_lv()
	for part in mod_diskutil.list_partitions():
		if not part in mod_lvm.list_pv():
			fscontainers.append('/dev/'+part)

	for part in fscontainers:
		fs=mod_filesys.probe_filesystem(part)
		if fs=='ext2/ext3':
			reslines.append('!'.join(mod_filesys.get_details_ext2(part)))
		elif fs=='reiser3':
			reslines.append('!'.join(mod_filesys.get_details_reiser3(part)))
		elif fs=='ntfs':
			reslines.append('!'.join(mod_filesys.get_details_ntfs(part)))
		elif fs=='lvm2':
			info=(part,'lvm2','<none>')
			reslines.append('!'.join(info))
		elif fs=='swap':
			reslines.append('!'.join(mod_filesys.get_details_swap(part)))
		else:
			info=(part,'unknown','<none>')
			reslines.append('!'.join(info))
	return reslines
