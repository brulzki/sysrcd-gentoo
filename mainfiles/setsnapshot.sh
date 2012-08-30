#!/bin/bash

if [ -n "${1}" ]
then
	newdate="${1}"
else
	newdate="$(date --date='1 days ago' +%Y%m%d)"
fi

for f in *.spec
do
	sed -i -e "s!^snapshot: [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]!snapshot: ${newdate}!g" ${f}
done

grep '^snapshot: ' *.spec

