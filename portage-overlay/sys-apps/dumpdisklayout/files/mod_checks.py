import re,os,commands
import mod_lvm

# -------------------------- check required progs/files---------------------
def check_requirements(reqprogs, reqfiles): # we need these programs/files
	for arg in reqprogs:
		(status, output) = commands.getstatusoutput('which %s' % arg)
		if status != 0 or len(output)==0:
			return (-1, 'error: command %s not found' % arg)
	for arg in reqfiles:
		if not os.path.isfile(arg) and not os.path.isdir(arg):
			return (-1, 'error: %s not found' % arg)
	return (0, 'ok')

def check_linux26(): # we need linux-2.6
	(status, output) = commands.getstatusoutput('uname -r')
	if status != 0:
		print 'Cannot check the linux version running'
		return -1
	if output[0:3] != '2.6':
		print 'This support only linux-2.6 or newer'
		return -1
	return (0, 'ok')

def check_lvmprogs(): # we need the lvm tools version 2
	lvmvers=mod_lvm.get_lvm_version()
	if lvmvers[0:2]=='2.':
		return (0, 'ok')
	else:
		return (-1, 'Cannot find lvm-tools version 2 (type "lvm version" for details)')

def check_lvm_status(status): # check the lvm status is as said in argument
	for lv in mod_lvm.list_lv():
		if mod_lvm.get_lv_status(lv).lower()!=status:
			return -1 # wrong status
	return 0 # ok
