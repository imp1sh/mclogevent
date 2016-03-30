#!/bin/bash
source config.bash
echo "START"
tail -Fn0 $logfile | \
while read line; do
	#echo "$line"
	echo "$line" | grep -m1 "$loginevent"
	if [ $? = 0 ]; then
		echo "found a login"
		if [ $waittimervalue -eq 1 ]; then
			echo "is first login for the last $waittimerlimit seconds"
			# grep usefull information
			username=$(echo $line |awk '{print $4}'|awk -F'[' '{print $1}')
			time=$(echo $line | awk '{print $1}')
			# send message
			yowsup-cli demos -c yowsup_config -s $group@g.us "User $username logged in at $time"
			echo "before $waittimervalue"
			let "waittimervalue=waittimervalue+1"
			echo "after $waittimervalue"
		elif [ $waittimervalue -eq $waittimerlimit ]; then
				echo "timerlimit of $waittimerlimit seconds reached"
				echo "setting value back to 1"
				waittimervalue=1
		fi 
	fi
done
