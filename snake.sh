#!/bin/bash

GAME_FPS=3

CMD_TICK=0
CMD_UP=1
CMD_LEFT=2
CMD_DOWN=3
CMD_RIGHT=4

cmd_tick() {
    #clear
    #printf "\xda"
    echo "tick"
}

cmd_up() {
    echo "UP"
}

cmd_left() {
    echo "LEFT"
}

cmd_down() {
    echo "DOWN"
}

cmd_right() {
    echo "RIGHT"
}

ticker() {
    delay=$(echo "1/$GAME_FPS" | bc -l)
    while true; do
        echo -n $CMD_TICK
        sleep $delay
    done
}

reader() {
    declare -A keysym_to_cmd
    keysym_to_cmd=([w]=$CMD_UP [a]=$CMD_LEFT [s]=$CMD_DOWN [d]=$CMD_RIGHT)
    while read -rsn1 keysym; do
        echo -n ${keysym_to_cmd[$keysym]}
    done
}

controller() {
    declare -A commands
    commands=([$CMD_TICK]=cmd_tick [$CMD_UP]=cmd_up [$CMD_LEFT]=cmd_left [$CMD_DOWN]=cmd_down [$CMD_RIGHT]=cmd_right)
    while true; do
        read -rsn1 cmd
        ${commands[$cmd]}
    done
}

( ticker & reader ) | ( controller )
