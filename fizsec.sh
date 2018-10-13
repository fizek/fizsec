#!/bin/bash
fizsec="/opt/fizsec"
grep 'authentication failure' /var/log/secure | egrep -o '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' > ${fizsec}/current
cat ${fizsec}/current | sort | uniq > ${fizsec}/banit

for makeban in $(cat ${fizsec}/banit)
do
	if ! grep -q "${makeban}" ${fizsec}/banned;then
		iptables -A INPUT -s ${makeban} -j DROP
		echo ${makeban} >> ${fizsec}/banned
	fi
done
