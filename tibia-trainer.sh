#!/bin/bash

# seed randômico
RANDOM=$$$(date +%s)

# array de movimentos
MOVIMENTOS=("Up" "Down" "Right" "Left" "Up+Down" "Down+Up" "Up+Left" "Down+Left")

function executa {
    if WIDS=$(xdotool search --name 'Tibia'); then
        for WID in $WIDS
	    do
	        if $(xwininfo -id $WID | grep -q IsViewable) 
		    then
			xdotool windowactivate ${WID} key --window ${WID} "Control_L+$MOV"
			#xdotool key --window ${WID} Control_L+$MOV
			xdotool windowminimize ${WID}
		    break
		fi
	    done
    else
        notify-send "Tibia not running"   
    fi
}

while true
do
    # segundo randômico
    SEGUNDORANDOMICO=$(shuf -i 450-800 -n 1)

    # movimento randômico
    MOV=${MOVIMENTOS[$RANDOM % ${#MOVIMENTOS[@]}]}

    dt=`date "+%d/%m/%Y %T"` 

    echo "[$dt] Movimento: $MOV | Segundos: $SEGUNDORANDOMICO"
    executa
    sleep $SEGUNDORANDOMICO
done
