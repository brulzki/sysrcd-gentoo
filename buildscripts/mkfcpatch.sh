#!/bin/bash

SPECFILE='/root/rpmbuild/SPECS/kernel.spec'
SOURCEDIR="/root/rpmbuild/SOURCES"
RESULTDIR="/var/tmp/RESULT"
TMPDIR='/var/tmp/MKKERPATCH'

# ============================ internal functions =================================
function full_patch_list()
{
	cat ${SPECFILE} | grep -E '^[[:space:]]*Apply' | grep -v '^\$' | grep -v '^\%' | grep -v '\%{' | grep -v '\%{' | grep -v '\${' | awk '{print $2,$3}' | grep -vE '^[[:space:]]$'
}

function filtered_patch_list()
{
	full_patch_list | grep -v linux-2.6-v4l-dvb
}

# ============================ determine variables ===============================
KERVERSION=$(cat ${SPECFILE} | grep '%define base_sublevel' | head -n 1 | awk '{print $3}') 
KERPATCHNR=$(cat ${SPECFILE} | grep '%define stable_update' | head -n 1 | awk '{print $3}')

KERBASEVER="2.6"
KERARCHIVE="${SOURCEDIR}/linux-${KERBASEVER}.${KERVERSION}.tar.bz2"
KERBZPATCH="${SOURCEDIR}/patch-${KERBASEVER}.${KERVERSION}.${KERPATCHNR}.bz2"
FCPATCHNAM="linux-${KERBASEVER}.${KERVERSION}.${KERPATCHNR}-fedora.patch"
PATCHDIR01="linux-${KERBASEVER}.${KERVERSION}-01"
PATCHDIR02="linux-${KERBASEVER}.${KERVERSION}-02"

echo "KERARCHIVE=${KERARCHIVE}"
echo "KERBZPATCH=${KERBZPATCH}"

# ============================ Prepare temp directories ===========================
rm -rf ${TMPDIR} 2>/dev/null
mkdir -p ${TMPDIR} 2>/dev/null
rm -rf ${RESULTDIR} 2>/dev/null
mkdir -p ${RESULTDIR} 2>/dev/null

# ============================ Prepare original sources ===========================
(
	cd ${TMPDIR}
	tar xf ${KERARCHIVE}
	cd "linux-${KERBASEVER}.${KERVERSION}"
	bzcat ${KERBZPATCH} | patch -p1 2>&1 | grep -vF 'patching file'
	cd ${TMPDIR}
	mv "linux-${KERBASEVER}.${KERVERSION}" "${PATCHDIR01}"
	cp -a "${PATCHDIR01}" "${PATCHDIR02}"
	du -sh ${TMPDIR}/*
)

# ============================ Apply all patches ==================================
filtered_patch_list | while read line
do
	patchfile=$(echo ${line} | awk '{print $1}')
	patchargs=$(echo ${line} | awk '{print $2}')
	patchsize=$(stat -c %s ${SOURCEDIR}/${patchfile} | awk '{print $1}')
	printsize=$(printf "%06d" ${patchsize})

	if [ "${patchargs}" = '-R' ]
	then
		patchtype="Revert"
	else
		patchtype="Apply "
	fi

	(
		cd "${TMPDIR}/${PATCHDIR02}"
		cat "${SOURCEDIR}/${patchfile}" | patch -p1 ${patchargs} 2>&1 | grep -vF 'patching file' | grep -vF 'succeeded' | grep -vF 'Only garbage was found'
		res=$?
		if [ ${res} -ne 1 ]
		then
			echo "FAILURE: ${patchtype} (size=${printsize}) ${patchfile} (res=${res})"
		else
			echo "SUCCESS: ${patchtype} (size=${printsize}) ${patchfile} (res=${res})"
		fi
	)
done

# ============================ Cleanup sources ======================================
(
	find ${TMPDIR} -iname "*.orig" -exec rm -f {} \;
	find ${TMPDIR} -iname "*.rej"
)

# ============================ Create final patches =================================
(
	cd ${TMPDIR}
	rm -f ${RESULTDIR}/${FCPATCHNAM}* 2>/dev/null
	diff -urN "${PATCHDIR01}" "${PATCHDIR02}" | bzip2 >| ${RESULTDIR}/${FCPATCHNAM}.bz2
	ls -lh ${RESULTDIR}/${FCPATCHNAM}*
)

# ============================ Final cleanup ========================================
rm -rf ${TMPDIR} 2>/dev/null

