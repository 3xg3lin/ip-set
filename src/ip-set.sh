#!/bin/bash

set -e
export _tmp_var="true"

if ! command -v "ip" &> /dev/null ; then
	echo "There is no \"ip\" command found!"
	export _tmp_var="false"
fi

if ! command -v "awk" &> /dev/null ; then
	echo "There is no \"awk\" command found!"
	export _tmp_var="false"
fi

if [[ "${_tmp_var}" == "false" ]] ; then
	exit 1
fi

if [[ -z "${PREFIX}" ]] ; then
	export PREFIX="/etc"
fi

source "${PREFIX}/ip-set.conf"

case "${1,,}" in
	("--list"|"-l")
		ip "a" | awk '$2 ~ /[^:]+:$/{print $2}'
	;;
	("--interface"|"-i")
		echo "${INTERFACE}"
	;;
	("--autoselect"|"-a")
		for i in $(ip "a" | awk '$2 ~ /[^:]+:$/{print $2}') ; do
			echo "${i}"
		done
	;;
	("--select"|"-s")
		export PS3="select an option:> "
		select i in $(ip "a" | awk '$2 ~ /[^:]+:$/{print $2}') "exit" ; do
			case "${i}" in
				("exit")
					exit 0
				;;
				(*)
					if [[ -n "${i}" ]] ; then
						echo "${i} - ${REPLY}"
					fi
				;;
			esac
		done
	;;
	("--set"|"-set")

	;;
	(*)
		echo -e "There is no parameter found! You can use;
\t--interfaces, -i: list network interfaces of the device
"
		exit 1
	;;
esac
