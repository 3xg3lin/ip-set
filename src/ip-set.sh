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

if ! $(command -v "sed" &> /dev/null)
then
    echo "There is no \"sed\" command found!"
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
		ip "a" | awk '$2 ~ /[^:]+:$/{print $2}'| sed 's/://g' ;;
	("--interface"|"-i")
		echo "${INTERFACE}" ;;
	("--select"|"-s")
		export PS3="select an option:> "
		select i in $(ip "a" | awk '$2 ~ /[^:]+:$/{print $2}' | sed 's/://g') "exit" ; do
			case "${i}" in
				("exit")
					exit 0 ;;
				(*)
					if [[ -n "${i}" ]] ; then
						selected="$i"
						echo "Selected interface is $selected"
						read -p "Enter ip address (xx.xx.xx.xx/xx)" ip
						ip addr add $ip dev $selected
						echo "It's all done"
					fi ;;
			esac
		done ;;
	("--set"|"-set")
		read -p "Enter ip address (xx.xx.xx.xx/xx)" ip
		ip addr add $ip dev $INTERFACE
		echo "It's all done" ;;
	(*)
		echo -e "There is no parameter found! You can use;
\t--interfaces, -i: list network interfaces of the device
"
		exit 1 ;;
esac
