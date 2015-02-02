#!/bin/bash

newdate="$(date --date='1 days ago' +%Y%m%d)"
sed -i -r -e "s/^snapshot: [0-9]{8}/snapshot: ${newdate}/g" *.spec
grep '^snapshot: ' *.spec

