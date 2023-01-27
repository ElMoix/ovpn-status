#!/bin/bash

logf=/var/log/openvpn/openvpn.log

dias=$(date | cut -d " " -f1)
# Dilluns
dian=$(date | cut -d " " -f2)
# 1
mes=$(date | cut -d " " -f3)
# Gener
any=$(date | cut -d " " -f4)
# 2023
ds='  '
# DoubleSpace

dateF=$(date +%d-%m-%Y)


# Fent aixo, guardarem cada fitxer per mes i any
OUTPUT=/tmp/$mes$any.html
INPUT=/var/www/html/$mes$any.html

if ! [ -f $INPUT ]; then
	touch $OUTPUT
	echo "<html>" >> $OUTPUT
	echo "<head>" >> $OUTPUT
	echo "<style>" >> $OUTPUT
	echo "h1 {text-align: center;}" >> $OUTPUT
	echo "</style>" >> $OUTPUT
	echo "</head>" >> $OUTPUT
	echo "<body>" >> $OUTPUT
	echo "<h1>DETALLS OPENVPN</h1>" >> $OUTPUT
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
                echo "<b>L'USUARI $users S'ACABA DE CONNECTAR</b>""<br>" >> $OUTPUT
                cat $logf | grep $port | grep "Peer Connection Initiated" >> $OUTPUT
                echo "<br>" >> $OUTPUT
                echo "<b>L'USUARI $users S'ACABA DE DESCONNECTAR</b>""<br>" >> $OUTPUT
                h=$(cat $logf | grep $port | grep "Inactivity timeout")
                if ! [[ -z "$h" ]];then
                        cat $logf | grep $port | grep "Inactivity timeout" >> $OUTPUT
                        echo "</p>" >> $OUTPUT
                        echo "<hr>" >> $OUTPUT
                else
                        echo "NO s'ha detectat la desconexio per varies connexions continues" >> $OUTPUT
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
                echo "<b>L'USUARI $users S'ACABA DE CONNECTAR</b>""<br>" >> $OUTPUT
                cat $logf | grep $port | grep "Peer Connection Initiated" >> $OUTPUT
                echo "<br>" >> $OUTPUT
                echo "<b>L'USUARI $users S'ACABA DE DESCONNECTAR</b>""<br>" >> $OUTPUT
		h=$(cat $logf | grep $port | grep "Inactivity timeout")
		if ! [[ -z "$h" ]];then
                	cat $logf | grep $port | grep "Inactivity timeout" >> $OUTPUT
                	echo "</p>" >> $OUTPUT
                	echo "<hr>" >> $OUTPUT
                else
                        echo "NO s'ha detectat la desconexio per varies connexions continues" >> $OUTPUT
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
echo "Mes $mes Dia $dian done"
