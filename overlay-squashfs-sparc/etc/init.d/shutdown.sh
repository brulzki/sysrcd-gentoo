# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

opts="-hd"
[[ ${INIT_HALT} != "HALT" ]] && opts="${opts}p"
[[ ${RC_DOWN_INTERFACE} == "yes" ]] && opts="${opts}i"

/sbin/halt "${opts}"

echo "System halted. You can turn off your computer."

# hmm, if the above failed, that's kind of odd ...
# so let's force a halt
/sbin/halt -f
