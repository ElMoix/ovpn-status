#!/bin/bash

logf=/var/log/openvpn/openvpn.log

dias=$(date | cut -d " " -f1) # Monday
dian=$(date | cut -d " " -f2) # 1
mes=$(date | cut -d " " -f3)  # January
any=$(date | cut -d " " -f4)  # 2023
ds='  '                       # DoubleSpace
dateF=$(date +%d-%m-%Y)

# We will generate 12 files by year
OUTPUT=/tmp/$mes$any.html
INPUT=/var/www/html/$mes$any.html

# Check if file exists
if ! [ -f $INPUT ]; then
	touch $OUTPUT
	echo "<html>" >> $OUTPUT
	echo "<head>" >> $OUTPUT
	echo "<style>" >> $OUTPUT
	echo "h1 {text-align: center;}" >> $OUTPUT
	echo "</style>" >> $OUTPUT
	echo "</head>" >> $OUTPUT
	echo "<body>" >> $OUTPUT
	echo "<h1>OPENVPN DETAILS</h1>" >> $OUTPUT
	echo "</body>" >> $OUTPUT
        echo "</html>" >> $OUTPUT
fi

echo "<html>" >> $OUTPUT
echo "<head>" >> $OUTPUT
echo "</head>" >> $OUTPUT
echo "<body>" >> $OUTPUT
echo "<details>" >> $OUTPUT
echo "<summary>$dateF</summary>" >> $OUTPUT

if (( $dian > 0 && $dian < 10));then
	cat $logf | grep "Peer Connection Initiated" | grep "$dias $mes${ds}$dian" | while IFS= read -r line;
	do
		port=$(echo $line | cut -d ":" -f4 | cut -d " " -f1)
                users=$(echo $line | cut -d "]" -f1 | cut -d "[" -f2)
                echo "<p>" >> $OUTPUT
                echo "<b>USER: {$users} JUST CONNECTED</b>""<br>" >> $OUTPUT
                cat $logf | grep $port | grep "Peer Connection Initiated" >> $OUTPUT
                echo "<br>" >> $OUTPUT
                echo "<b>USER: {$users} JUST DISCONNECTED</b>""<br>" >> $OUTPUT
                h=$(cat $logf | grep $port | grep "Inactivity timeout")
                if ! [[ -z "$h" ]];then
                        cat $logf | grep $port | grep "Inactivity timeout" >> $OUTPUT
                        echo "</p>" >> $OUTPUT
                        echo "<hr>" >> $OUTPUT
                else
                        echo "TOO MANY SUCCESSFULLY CONNECTIONS - PEER NOT DISCONNECTED" >> $OUTPUT
			echo "</p>" >> $OUTPUT
                        echo "<hr>" >> $OUTPUT
                fi
	done
else
	cat $logf | grep "Peer Connection Initiated" | grep "$dias $mes $dian" | while IFS= read -r line;
	do
		port=$(echo $line | cut -d ":" -f4 | cut -d " " -f1)
                users=$(echo $line | cut -d "]" -f1 | cut -d "[" -f2)
		echo "<p>" >> $OUTPUT
                echo "<b>USER: {$users} JUST CONNECTED</b>""<br>" >> $OUTPUT
                cat $logf | grep $port | grep "Peer Connection Initiated" >> $OUTPUT
                echo "<br>" >> $OUTPUT
                echo "<b>USER: {$users} JUST DISCONNECTED</b>""<br>" >> $OUTPUT
		h=$(cat $logf | grep $port | grep "Inactivity timeout")
		if ! [[ -z "$h" ]];then
                	cat $logf | grep $port | grep "Inactivity timeout" >> $OUTPUT
                	echo "</p>" >> $OUTPUT
                	echo "<hr>" >> $OUTPUT
                else
                        echo "TOO MANY SUCCESSFULLY CONNECTIONS - PEER NOT DISCONNECTED" >> $OUTPUT
			echo "</p>" >> $OUTPUT
                        echo "<hr>" >> $OUTPUT
                fi
	done
fi
echo "</details>" >> $OUTPUT
echo "</body>" >> $OUTPUT
echo "</html>" >> $OUTPUT

cat $OUTPUT >> $INPUT
rm $OUTPUT
echo "LOG: Month $mes DAY $dian done"
