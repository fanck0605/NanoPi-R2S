#!/bin/sh

    getgw() {
		gw=$(ifconfig pppoe-${1} | grep inet | awk '{print $3}' | cut -c 7-)
		echo $gw
    }


	erri=0
	while true
	do
		gw=$(getgw $1)
		if [ ${#gw} -lt 4 ];then
			#echo "Get gateway error..."
			ifup ${1}
			sleep 3
			continue
		fi
		#echo "Ping----${gw}-------"
		ping -c 1 -W 1 $gw > /dev/null
		if [ $? -eq 0 ];then
			echo 'ok'
			sleep 2
		else
			erri=$(( $erri + 1 ))
			#echo "Ping ateway error ${erri} times..."
			sleep 1
		fi
		
		if [ $erri -ge 3 ];then
			#echo "Gateway missing......re-dial.."
			erri=0
			ifdown ${1} && ifup ${1}
			sleep 15
		fi	
	done

