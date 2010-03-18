import re,os,commands,sys

def list_pv():
	res=[]
	(status, output) = commands.getstatusoutput('pvdisplay -c')
	if status!=0: return []
	for line in output.splitlines():
		data=line.strip("\r\n").strip().split(':')
		if len(data)!=12: continue
		res.append(data[0])
	return res

def get_pv_details(pv):
	(status, output) = commands.getstatusoutput('pvdisplay -c')
	if status != 0:	return []
	for line in output.splitlines():
		data=line.strip("\r\n").strip().split(':')
		if len(data)!=12: continue
		if data[0]==pv:	return data
	return []

def list_vg():
	res=[]
	(status, output) = commands.getstatusoutput('vgdisplay -c')
	if status != 0: return []
	for line in output.splitlines():
		data=line.strip("\r\n").strip().split(':')
		if len(data)!=17: continue
		res.append(data[0])
	return res

def get_vg_details(vg):
	(status, output) = commands.getstatusoutput('vgdisplay -c')
	if status != 0: return []
	for line in output.splitlines():
		data=line.strip("\r\n").strip().split(':')
		if len(data)!=17: continue
		if data[0]==vg:	return data
	return []

def list_lv():
	res=[]
	(status, output) = commands.getstatusoutput('lvdisplay -c')
	if status != 0: return []
	for line in output.splitlines():
		data=line.strip("\r\n").strip().split(':')
		if len(data)!=13: continue
		res.append(data[0])
	return res

def get_lv_status(lv):
	(status, output) = commands.getstatusoutput('lvdisplay '+lv)
	if status != 0: return ''
	for line in output.splitlines():
		line=line.strip()
		if not re.match('^LV Status', line): continue
		line=line.replace('LV Status','').strip()
		return line
	return ''	

def get_lv_details(lv):
	(status, output) = commands.getstatusoutput('lvdisplay -c')
	if status != 0: return []
	for line in output.splitlines():
		data=line.strip("\r\n").strip().split(':')
		if len(data)!=13: continue
		if data[0]==lv:	return data
	return []

# says the lvm version that has been used to create an LVM-Volume-Group
def get_vg_format(vg):
	(status, output) = commands.getstatusoutput('vgdisplay %s' % vg)
	if status != 0: return 'unknown-format'
	for line in output.splitlines():
		line=line.strip().strip("\r\n")
		if (re.match('^Format',line)):
			return line.strip("\r\n").split()[1]
	return 'unknown-format'

# we need the lvm tools version 2
def get_lvm_version(): 
	(status, output) = commands.getstatusoutput('lvm version')
	if status!=0: return ''
	for line in output.splitlines():
		line=line.strip("\r\n").strip()
		if (re.match('^LVM version',line)):
			version=line.split()[2]
			return version
	return ''
