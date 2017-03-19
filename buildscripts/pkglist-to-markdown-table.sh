#!/bin/sh
# Convert the raw package-list to mediawiki table format
# usage: cat sysresccd-packages-list.txt | ./pkglist-to-wm-table.sh > pkglist-for-mediawiki.txt
# input: gentoo package-list, one package per line such as "sys-block/parted-1.7.1
# output: table formatted with the wikipedia syntax
# goal: prepare the package list for the website

ignore="dev-libs dev-util media-fonts media-libs sys-libs virtual x11-apps x11-libs x11-proto x11-misc perl-core dev-perl dev-cpp net-libs net-nds sys-devel virtual"

echo "|         **Category**         |                    **Package**                   |"
echo "|:----------------------------:|:------------------------------------------------:|"

rm -f /tmp/pkglist.txt
echo $ignore | sed -e "s/ /\n/g" > /tmp/pkglist.txt

row=0
while read package
do
	echo "$package" | grep -q -f /tmp/pkglist.txt 
	if [ "$?" != '0' ]
	then
		category=$(echo $package | cut -d/ -f1)
		pkgname=$(echo $package | cut -d/ -f2)
		printf "|%-30s|%-50s|\n" "${category}" "${pkgname}"
	fi
done

