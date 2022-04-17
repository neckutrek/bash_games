#!/bin/bash

source_dir=$(dirname "$0")
source $source_dir/utils.sh

GAME_FPS=5

CMD_TICK=0
CMD_UP=1
CMD_LEFT=2
CMD_DOWN=3
CMD_RIGHT=4

SNAKE_X=5
SNAKE_Y=5
SNAKE_DIR=0 # 0-R, 1-U, 2-L, 3-D

HEIGHT=30
WIDTH=80

screen_buffer=()
CTL=$(dec_to_char 43)
CT=$(dec_to_char 45)
CTR=$(dec_to_char 43)
CL=$(dec_to_char 124)
CR=$(dec_to_char 124)
CBL=$(dec_to_char 43)
CB=$(dec_to_char 45)
CBR=$(dec_to_char 43)

update_position() {
    #local dx, dy
    dx=0
    dy=0

    case $SNAKE_DIR in 
        0) dx=1 ;;
        1) dy=-1 ;;
        2) dx=-1 ;;
        3) dy=1 ;;
    esac
    
    SNAKE_X=$(( $SNAKE_X + $dx))
    if [[ $SNAKE_X -lt 0 ]]; then SNAKE_X=0; fi
    if [[ $SNAKE_X -gt $WIDTH ]]; then SNAKE_X=$WIDTH; fi
    
    SNAKE_Y=$(( $SNAKE_Y + $dy))
    if [[ $SNAKE_Y -lt 0 ]]; then SNAKE_Y=0; fi
    if [[ $SNAKE_Y -gt $HEIGHT ]]; then SNAKE_Y=$HEIGHT; fi
}

update_screen_buffer() {
    sb=()
    sb+=(${CTL}$(repeat $WIDTH ${CT})${CTR})
    for (( y=0; y<$HEIGHT; y++ ))
    do
        line=${CL}
        for (( x=0; x<$WIDTH; x++ ))
        do
            if [[ $x -eq $SNAKE_X && $y -eq $SNAKE_Y ]]
            then
                line=${line}'o'
            else
                line=${line}' '
            fi
        done
        line=${line}${CR}
        sb+=("${line}")
    done
    sb+=(${CBL}$(repeat $WIDTH ${CB})${CBR})
    screen_buffer=("${sb[@]}")
}

cmd_tick() {
    update_position
    update_screen_buffer
}

cmd_up() {
    SNAKE_DIR=1
}

cmd_left() {
    SNAKE_DIR=2
}

cmd_down() {
    SNAKE_DIR=3
}

cmd_right() {
    SNAKE_DIR=0
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
        clear
        for (( i=0; i<${#screen_buffer[@]}; ++i)); do
            echo -e "${screen_buffer[$i]}"
        done
    done
}

( ticker & reader ) | ( controller )
