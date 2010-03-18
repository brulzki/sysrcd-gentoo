#!/bin/sh
# Gives the list of installed packages on a gentoo system
# Usage: listpackages.sh < pkglist.txt
# pkglist is a list of packages such as app-arch/dar
# In output, the script gives the package followed by the version

i=1
while read package 
do
	equery -C -q list -i -e $package | awk '{print $1}'
done

