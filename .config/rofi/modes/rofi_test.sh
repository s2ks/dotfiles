#!/bin/bash

my_input() {
	sleep 5

	echo "hello"
}

input="$(mktemp)"
trap "rm $input" exit

coproc rofi { rofi -dmenu -async-pre-read 0 -format i:f; }

sleep 1
echo -en "hello\n" >&"${rofi[1]}"
sleep 1
echo -en "hello\n" >&"${rofi[1]}"
sleep 1
echo -en "hello\n" >&"${rofi[1]}"
sleep 1
echo -en "hello\n" >&"${rofi[1]}"
sleep 1
echo -en "hello\n" >&"${rofi[1]}"
sleep 1

