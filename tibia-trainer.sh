#!/bin/bash

RANDOM=$$$(date +%s)

ultimoMovimento="Down"

dt=`date "+%d/%m/%Y %T"` 
echo "[$dt] Iniciando treinamento"

while getopts ":c:m:" opt
   do
     case $opt in
        c) comida=$OPTARG;;
        m) magia=$OPTARG;;
     esac
done

function getMovimento {
	local movimentos=("Up" "Down" "Right" "Left" "Up+Down" "Up+Left" "Up+Right")
	echo ${movimentos[$RANDOM % ${#movimentos[@]}]}
}

function executa () {
    if WIDS=$(xdotool search --name 'Tibia'); then
        for WID in $WIDS
	    do
	        if $(xwininfo -id $WID | grep -q IsViewable) 
		    then
			xdotool windowactivate ${WID} key --window ${WID} "$1"
			xdotool windowminimize ${WID}
		    break
		fi
	    done
    else
        notify-send "Tibia not running"   
    fi
}

function movimento () {
	while true 
	do
		local dt=`date "+%d/%m/%Y %T"` 
		mov=$(getMovimento)
		executa "Control_L+$mov"

		sqlite3 tibia-trainer.db  "insert into log (tipo, comando) values ('movimento','$mov');"

		echo "[$dt] Movimento executado: $mov"

	    #segundosRandom=$(shuf -i 450-800 -n 1)
		#sleep $segundosRandom
	done
}

function comer () {
	while true 
	do
		local dt=`date "+%d/%m/%Y %T"` 

		sqlite3 tibia-trainer.db  "insert into log (tipo, comando) values ('comida','$1');"

		echo "[$dt] Comida executada: $1"

	    segundosRandom=$(shuf -i 10-60 -n 1)
		sleep $segundosRandom
	done
}

function magia () {
	while true 
	do
		local dt=`date "+%d/%m/%Y %T"` 

		sqlite3 tibia-trainer.db  "insert into log (tipo, comando) values ('magia','$1');"

		echo "[$dt] Magia executada: $1"

	    segundosRandom=$(shuf -i 10-60 -n 1)
		sleep $segundosRandom
	done
}

while true
do
    # segundo randômico
    #SEGUNDORANDOMICO=$(shuf -i 450-800 -n 1)
	movimento
	
	if [-n $comida]; then 
		echo "[$dt] Comida enviada: $comida"
		comer $comida
	fi

	[${magia}] magia $magia

    # movimento randômico
    #movimentoAtual=$(getMovimento)

    #echo "[$dt] Movimento: $movimentoAtual | Ultimo: $ultimoMovimento | Segundos: $SEGUNDORANDOMICO"
    #executa
	#sleep 1
    #sleep $SEGUNDORANDOMICO

	#ultimoMovimento=$movimentoAtual
done
