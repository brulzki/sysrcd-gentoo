import sys, os
sys.path.append(os.path.abspath(os.curdir))
sys.path.append('/usr/lib/dumpdisklayout/modules/')
import re,os,commands,sys,datetime
import mod_checks
import mod_filesys
import mod_diskutil

FILEFORMVER='0.1.1'
hddlist=[] # list of harddisks found in the layout-file
volgroup={} # list of volume-groups and their pvs

# -------------------------------------------------------------------------------------
def check_filefmt(inlines):
	for line in inlines:
		if not re.match('^fileformat!',line): continue
		filefmt=line.split('!')[1]
		if filefmt==FILEFORMVER:
			return 0
		else:
			print 'found file format %s and expected %s' % (filefmt, FILEFORMVER)
			return -1
	return -1

def check_physhdd(inlines):
        for line in inlines:
                if not (re.match('[:alnum:]*|[0-9]*![:alnum:]*![:alnum:]*', line)): continue
		(dev,size,vendor,model)=line.split('!')
		if not dev in mod_diskutil.list_disks():
			print 'Cannot find hard disk %s'%devname
			return -1
		devname='/dev/'+dev
		cursize=file('/sys/block/%s/size'%dev).readline().strip("\r\n").strip()
		if cursize==size:
			hddlist.append(dev)
		else:
			print 'size of hard disk does not match for device %s'%devname
			return -1
        return 0

def rest_sfdisk(inlines):
	for hdd in hddlist:
		sfdiskdat=''
		for line in inlines:
			if not re.match('^%s!'%hdd, line): continue
			line=line.replace('%s!'%hdd,'')
			sfdiskdat+=line+'\n'
		print sfdiskdat
		if sfdiskdat=='': continue
		cmd='echo "%s" | sfdisk /dev/%s'%(sfdiskdat,hdd)
		(status, output) = commands.getstatusoutput(cmd)
		print 'sfdisk returned %s'%status
		if not int(status) in (0,256):
			print 'sfdisk failed to restore disk /dev/%s'%hdd
			return -1
	return 0

def rest_pv(inlines):
	for line in inlines:
		data=line.split('!')
		if len(data)!=12: continue
		(devname,vgname,uuid)=(data[0],data[1],data[11])
		if not volgroup.has_key(vgname): 
			volgroup[vgname]=(devname+' ')
		else:
			volgroup[vgname]+=(devname+' ')
		commands.getstatusoutput('dd if=/dev/zero of=%s count=400 bs=512'%devname)
		cmd='pvcreate -ff -Zy -u %s %s'%(uuid, devname)
		print 'pv_exec %s'%cmd
		(status, output) = commands.getstatusoutput(cmd)
		if status!=0:
			print 'pvcreate failed (%s) with status %s'%(cmd,status)
			return -1
	return 0

def rest_vg(inlines):
	for line in inlines:
		data=line.split('!')
		if len(data)!=18: continue
		(vgname,uuid,lvmvers)=(data[0],data[16],data[17])
		cmd='vgcreate %s %s'%(vgname, volgroup[vgname])
		print 'vg_exec %s'%cmd
		(status, output) = commands.getstatusoutput(cmd)
		if status!=0:
			print 'vgcreate failed (%s) with status %s'%(cmd,status)
			return -1
	return 0

def rest_lv(inlines):
	for line in inlines:
		data=line.split('!')
		if len(data)!=13: continue
		lvname=data[0].split('/')[-1]
		vgname=data[1]
		lvsize=int(data[6])/2
		commands.getstatusoutput('dd if=/dev/zero of=%s count=4 bs=512'%data[0])
		cmd='lvcreate -n %s -L %sk %s'%(lvname, lvsize, vgname)
		print 'lv_exec %s'%cmd
		(status, output) = commands.getstatusoutput(cmd)
		if status!=0:
			print 'lvcreate failed (%s) with status %s'%(cmd,status)
			return -1
	return 0

def rest_fs(inlines):
	for line in inlines:
		if len(line.split('!'))!=4: continue
		(devname,filesys,label,attrib)=line.split('!')
		res=mod_filesys.format(devname, filesys, label, attrib)
		if res!=0:
			print 'failed to format device %s'%devname
			return -1
	return 0
