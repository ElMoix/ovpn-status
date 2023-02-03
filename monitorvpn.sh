#!/bin/bash

logf=/var/log/openvpn/openvpn.log

dias=$(date | cut -d " " -f1) # Monday
dian=$(date | cut -d " " -f2) # 10-31
dians=$(date | cut -d " " -f2 | sed s/0//g) # 0-9
mes=$(date | cut -d " " -f3)  # January
any=$(date | cut -d " " -f4)  # 2023
ds='  '                       # DoubleSpace
dateF=$(date +%d-%m-%Y)

# We will generate 12 files by year
OUTPUT=/tmp/$mes$any.html
INPUT=/var/www/html/$mes$any.html

vcheck=$(openvpn --version | head -n 1)

# Check if file exists
if ! [ -f $INPUT ]; then
	touch $OUTPUT
	echo "<html>" >> $OUTPUT
	echo "<head>" >> $OUTPUT
	echo "<style>" >> $OUTPUT
	echo "h1 {text-align: center;}" >> $OUTPUT
        echo "h3 {text-align: center;}" >> $OUTPUT
	echo ".stt {
  position: fixed;
  right: 1rem;
  bottom: 1rem;
  width: 4rem;
  text-align: center;
  height: 2rem;
  background: rgb(178, 151, 222);}" >> $OUTPUT
	echo "</style>" >> $OUTPUT
	echo "</head>" >> $OUTPUT
	echo "<body>" >> $OUTPUT
	echo "<h1 style='border: 4px solid Tomato;'>OPENVPN DETAILS</h1>" >> $OUTPUT
	echo "<h3 style='border: 4px solid Tomato;'>$vcheck</h3>" >> $OUTPUT
	echo "<br>" >> $OUTPUT
	echo "</body>" >> $OUTPUT
        echo "</html>" >> $OUTPUT
fi

echo "<html>" >> $OUTPUT
echo "<head>" >> $OUTPUT
echo "</head>" >> $OUTPUT
echo "<body>" >> $OUTPUT
echo "<a href='#' class='stt' title='top'>TOP</a>" >> $OUTPUT
echo "<details>" >> $OUTPUT
echo "<summary>$dateF</summary>" >> $OUTPUT

if (( $dian > 0 && $dian < 10));then
	cat $logf | grep "Peer Connection Initiated" | grep "$dias $mes${ds}$dians" | while IFS= read -r line;
	do
                port=$(echo $line | cut -d ":" -f4 | cut -d " " -f1)
                users=$(echo $line | cut -d "]" -f1 | cut -d "[" -f2)
                echo "<p>" >> $OUTPUT
                echo "<b>USER: {$users} JUST CONNECTED</b>""<br>" >> $OUTPUT
                timel=$(cat $logf | grep $port | grep "Peer Connection Initiated" | cut -d "=" -f1 | sed 's/us//g')
                echo "<a style='color:#299b26;'>TIME: </a>$timel<br>" >> $OUTPUT
                ipl=$(cat $logf | grep $port | grep "Peer Connection Initiated" | cut -d "[" -f1 | cut -d "=" -f2 | cut -d " " -f2 | cut -d ":" -f1)
                echo "<a style='color:#299b26;'>IP:</a>$ipl<br>" >> $OUTPUT
                stat=$(cat $logf | grep $port | grep "Peer Connection Initiated" | cut -d "]" -f2 | cut -d "[" -f1 | sed 's/with//g')
                echo "<a style='color:#299b26;'>STATUS:</a>$stat<br>" >> $OUTPUT
                echo "<br>" >> $OUTPUT
                echo "<b>USER: {$users} JUST DISCONNECTED</b>""<br>" >> $OUTPUT
                h=$(cat $logf | grep $port | grep $mes | grep "Inactivity timeout")
                if ! [[ -z "$h" ]];then
                        timed=$(cat $logf | grep $port | grep "Inactivity timeout" | cut -d "=" -f1 | sed 's/us//g')
                        echo "<a style='color:#299b26;'>TIME: </a>$timed<br>" >> $OUTPUT
                        ipd=$(cat $logf | grep $port | grep "Inactivity timeout" | cut -d "[" -f1 | cut -d "=" -f2 | cut -d " " -f2 | cut -d ":" -f1)
                        echo "<a style='color:#299b26;'>IP: </a>$ipd<br>" >> $OUTPUT
                        statd=$(cat $logf | grep $port | grep "Inactivity timeout" | cut -d "]" -f2 | cut -d "[" -f1 | sed 's/with//g')
                        echo "<a style='color:#299b26;'>STATUS: </a>$statd<br>" >> $OUTPUT
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
		timel=$(cat $logf | grep $port | grep "Peer Connection Initiated" | cut -d "=" -f1 | sed 's/us//g')
		echo "<a style='color:#299b26;'>TIME: </a>$timel<br>" >> $OUTPUT
		ipl=$(cat $logf | grep $port | grep "Peer Connection Initiated" | cut -d "[" -f1 | cut -d "=" -f2 | cut -d " " -f2 | cut -d ":" -f1)
		echo "<a style='color:#299b26;'>IP:</a>$ipl<br>" >> $OUTPUT
		stat=$(cat $logf | grep $port | grep "Peer Connection Initiated" | cut -d "]" -f2 | cut -d "[" -f1 | sed 's/with//g')
		echo "<a style='color:#299b26;'>STATUS:</a>$stat<br>" >> $OUTPUT
                echo "<br>" >> $OUTPUT
                echo "<b>USER: {$users} JUST DISCONNECTED</b>""<br>" >> $OUTPUT
		h=$(cat $logf | grep $port | grep $mes | grep "Inactivity timeout")
		if ! [[ -z "$h" ]];then
			timed=$(cat $logf | grep $port | grep "Inactivity timeout" | cut -d "=" -f1 | sed 's/us//g')
	                echo "<a style='color:#299b26;'>TIME: </a>$timed<br>" >> $OUTPUT
			ipd=$(cat $logf | grep $port | grep "Inactivity timeout" | cut -d "[" -f1 | cut -d "=" -f2 | cut -d " " -f2 | cut -d ":" -f1)
	                echo "<a style='color:#299b26;'>IP: </a>$ipd<br>" >> $OUTPUT
        	        statd=$(cat $logf | grep $port | grep "Inactivity timeout" | cut -d "]" -f2 | cut -d "[" -f1 | sed 's/with//g')
                	echo "<a style='color:#299b26;'>STATUS: </a>$statd<br>" >> $OUTPUT
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

